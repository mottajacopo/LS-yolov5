FROM python:latest

RUN apt update && apt install libgl1-mesa-glx -y

WORKDIR /yolov5-ml-backend

COPY yolov5 /yolov5-ml-backend/yolov5

RUN pip install -r yolov5/requirements.txt

COPY label-studio-ml-backend /yolov5-ml-backend/label-studio-ml-backend

RUN pip install -U -e label-studio-ml-backend

RUN pip install redis rq

ENV LABEL_STUDIO_ML_BACKEND_V2=true

RUN wget -O yolov5.pt https://github.com/ultralytics/yolov5/releases/download/v6.2/yolov5l.pt

COPY main.py /yolov5-ml-backend/main.py

ENV LABEL_STUDIO_ML_BACKEND_V2=true

RUN label-studio-ml init yolov5-server --script ./main.py --force

CMD ["label-studio-ml", "start", "yolov5-server"]

