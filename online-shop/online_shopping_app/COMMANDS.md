# Commands - Online Shopping Protal

1. Cloning Repository
    ```powershell
    git clone REPOSITORY
    ```

2. Installing Docker and Docker Compose
    ```powershell
    chmod +x docker_installation.sh
    ./docker_installation.sh
    sudo usermod -aG docker $USER
    sudo systemctl start docker
    ```

3. Building Dockerfile
    ```powershell
    docker build -t online_store:v1 .
    docker tag -t muhammadabdullahabrar/practice:online_store
    docker push muhammadabdullahabrar/practice:online_store
    ```
4. Implementing Docker Compose
    ```powershell
    docker-compose up -d
    ```
5. Using Docker Scout
    ```powershell
    docker scout cves online_store:v1 --format markdown >> image_report.md
    ```
6. Testing and Checking

---