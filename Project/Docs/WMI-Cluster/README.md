# Useful Information for Using the UAM Computational Cluster:

Cluster documentation: https://cluster.wmi.amu.edu.pl/

Access data:
- Login: ***index UAM***
- Account valid until: 2025-09-01
- Quota -> current usage

<br>

### NOTE:
After finishing your work, remember to cancel the maximum reservation!

``` bash
scancel <id>

scancel --me
```

<br>

## Running Conda:

``` bash
module load anaconda

conda create --name <nazwa> python=3.12

conda activate <nazwa> 
```

## Connecting to the Computational Cluster:

### Steps:
1. Connect via SSH to the access machine:
   
   ``` bash 
   ssh s444820@access.cluster.wmi.amu.edu.pl
   ```

2. ZManage the maximum GPU reservation:

    ``` bash
    salloc --no-shell --partition=gpu --exclusive --gres=gpu:1 --time=12:00:0
    ```
    You will receive a session ID and server name, e.g., g1n1 (save it!)

3. Connect via SSH to the computational cluster:
   
   ``` bash
    ssh g1n1
   ```

<br>

## Working with the LLaMa3:8b Language ModelL

1. Download the Docker image and convert it to Singularity/Apptainer format:
    ``` bash
    apptainer build ollama.sif docker://ollama/ollama:0.1.37
    ```

2. Create a directory for data that will be mounted to the running container:

    ``` bash
    mkdir ollama_data
    ```
   
    ``` bash
    apptainer run --containall --bind /tmp:/tmp --bind ./ollama_data:/home/s444820/ --nv ollama.sif
    ```

<br>


## Working with SearXNG:

``` bash
apptainer build --sandbox my_sandbox_dir sxng.sif
cd my_sandbox_dir/etc/
mkdir searxng
cd searchxng/
vim settings.yml
vim uwsgi.ini
apptainer build new_good.sif my_sandbox_dir
apptainer run new_good.sif
```