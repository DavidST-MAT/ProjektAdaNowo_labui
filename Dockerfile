# Verwenden Sie das offizielle Nginx-Base-Image
FROM nginx:latest

# Kopieren Sie den Build-Ordner Ihrer Vue.js-Anwendung in das Nginx-Standardverzeichnis
COPY dist/ /usr/share/nginx/html

# Konfigurationsdatei für Nginx kopieren
COPY nginx.conf /etc/nginx/nginx.conf

# Port, auf dem der Nginx-Server ausgeführt wird
EXPOSE 8080

# Nginx starten
CMD ["nginx", "-g", "daemon off;"]
