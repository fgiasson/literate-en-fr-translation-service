# AUTOGENERATED! DO NOT EDIT! File to edit: ../nbs/00_download_models.ipynb.

# %% auto 0
__all__ = ['download_model']

# %% ../nbs/00_download_models.ipynb 4
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import os

# %% ../nbs/00_download_models.ipynb 6
def download_model(model_path, model_name):
    """Download a Hugging Face model and tokenizer to the specified directory"""
    # Check if the directory already exists
    if not os.path.exists(model_path):
        os.makedirs(model_path)

    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForSeq2SeqLM.from_pretrained(model_name)

    # Save the model and tokenizer to the specified directory
    model.save_pretrained(model_path)
    tokenizer.save_pretrained(model_path)


# %% ../nbs/00_download_models.ipynb 8
#| eval: false
download_model('models/en_fr/', 'Helsinki-NLP/opus-mt-en-fr')
download_model('models/fr_en/', 'Helsinki-NLP/opus-mt-fr-en')
