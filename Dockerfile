# --- Build stage ---
FROM node:18-alpine AS builder

# Installer les dépendances pour node-gyp et sharp
RUN apk add --no-cache python3 make g++ git

WORKDIR /app

# Copier uniquement package.json + package-lock.json pour optimiser le cache
COPY package*.json ./

# Installer toutes les dépendances (y compris devDependencies)
RUN npm ci

# Copier le reste du code
COPY . .

# Build Next.js
RUN npm run build

# --- Run stage ---
FROM node:18-alpine AS runner

WORKDIR /app

# Installer uniquement les packages nécessaires pour la production
COPY --from=builder /app ./

# Next.js production server
EXPOSE 3000

ENV NODE_ENV=production

CMD ["npm", "start"]
