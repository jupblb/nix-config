# Agenix Secrets

## Steps to add a new secret

1.  **Create the encrypted secret file**:

    ``` bash
    cd hosts/secret
    echo "YOUR_SECRET_VALUE" | agenix -e secret_name.age
    ```

2.  **Update secrets.nix** to register the secret:

    ``` nix
    "secret_name.age".publicKeys = [ common dionysus ];
    ```

3.  **Use the secret in host configuration** (e.g., dionysus.nix):

    ``` nix
    age.secrets.secret-name = {
      file = ./secret/secret_name.age;
      owner = "service-user";  # optional
    };

    # Reference the decrypted path:
    services.example.configFile = config.age.secrets.secret-name.path;
    ```
