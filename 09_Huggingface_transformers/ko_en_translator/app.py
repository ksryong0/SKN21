# ko_en_translator/app.py
## Higgingface transformers.pipeline을 이용해서 한국어를 영어로 번역하는 app
import streamlit as st
from transformers import pipeline


def get_model():
    model = "Helsinki-NLP/opus-mt-ko-en"
    