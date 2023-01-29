# Label Studio Yolov5 ML Backend
This repo allow you tu use yolov5 models in label studio ml backend.

## Run Label Studio on Docker and use local storage
```shell
docker pull heartexlabs/label-studio:latest
docker run -it -p 8080:8080 -v $(pwd)/mydata:/label-studio/data \
--env LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true \ 
--env LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT=/label-studio/files \ 
-v $(pwd)/myfiles:/label-studio/files \
heartexlabs/label-studio:latest label-studio

#es.
docker run -d -p 8080:8080 --restart=always --name label-studio -v $(pwd)/mydata:/label-studio/data --env LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true --env LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT=/label-studio/files -v /ai-data/project/datasets:/label-studio/files  heartexlabs/label-studio:latest label-studio
```

## Set up Label Studio ML backend for yolov5
Clone repostory with submodules
```shell
git clone https://github.com/mottajacopo/LS-yolov5.git
git submodule update --init --recursive
```

## Installation
Install requirements
```shell
pip install -r yolov5/requirements.txt  # yolo requirements
pip install -U -e label-studio-ml-backend  # install label studio backend
pip install redis rq  # additional libraries for the backend
```

## Running backend
```shell
cd LS-yolov5
export LABEL_STUDIO_ML_BACKEND_V2=true
wget -O yolov5.pt https://github.com/ultralytics/yolov5/releases/download/v6.2/yolov5l.pt

label-studio-ml init minecraft_copilot --script ./main.py --force
label-studio-ml start minecraft_copilot
```
The ML backend server becomes available at http://localhost:9090

## Running with docker
```shell
cd LS-yolov5
docker build -t label-studio-yolov5-backend .
docker run -it --name label-studio-yolov5-ml-backend \
-p 9090:9090 --gpus all --shm-size=8192M \
-v path-to-local-storage:/data/local-files \
-v path-to-label-studio-upload-folder:/data/upload \
label-studio-yolov5-backend 

#es.
docker run -d --restart=always --name label-studio-yolov5-ml-backend -p 9090:9090 --gpus all --shm-size=8192M -v /ai-data/project/datasets/:/data/local-files -v /ai-data/project/LabelStudio/mydata/media/upload/:/data/upload label-studio-yolov5-backend
```

## Connecting to ML backend
Add an ML backend using the Label Studio UI

* In the Label Studio UI, open the project that you want to use with your ML backend.
* Click Settings > Machine Learning.
* Click Add Model.
* Type a Title for the model and provide the URL for the ML backend. For example, http://localhost:9090.
* Click Validate and Save.

> **_NOTE:_**  At the moment only auto labeling using pre-trained models is supported. Training not yet implemented.

## Credits
- [ultralytics/yolov5](https://github.com/ultralytics/yolov5.git)
- [heartexlabs/label-studio-ml-backend](https://github.com/heartexlabs/label-studio-ml-backend.git)
- [pavtiger/label-studio-yolo-ml-backend](https://github.com/pavtiger/label-studio-yolo-ml-backend.git)

