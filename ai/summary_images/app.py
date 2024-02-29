from dotenv import load_dotenv
import streamlit as st
from langchain.text_splitter import CharacterTextSplitter
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.vectorstores import FAISS
from langchain.chains.question_answering import load_qa_chain
from langchain.llms import OpenAI
from langchain.callbacks import get_openai_callback
import pytesseract
from PIL import Image

def main():
    raw_file= "extracted.txt"
    response_file= "response.txt"
    
    load_dotenv()
    st.set_page_config(page_title="Sumarize From Images")
    st.header("Summarize from Images 💬")

    # upload files
    uploaded_files = st.file_uploader("Upload your files", type=["jpg"], accept_multiple_files=True)

    # extract text from uploaded files
    all_text = ""
    for uploaded_file in uploaded_files:
        # Open the image file
        image = Image.open(uploaded_file)

        # Perform OCR using PyTesseract
        text = pytesseract.image_to_string(image)

        # Print the extracted text
        all_text += text
    
    # # split into chunks
    text_splitter = CharacterTextSplitter(
        separator="\n",
        chunk_size=1000,
        chunk_overlap=200,
        length_function=len
    )
    chunks = text_splitter.split_text(all_text)
  
    # create embeddings
    if len(uploaded_files) > 0:
        embeddings = OpenAIEmbeddings()
        knowledge_base = FAISS.from_texts(texts=chunks, embedding=embeddings)  # Update the parameter names

        # show user input
        user_question = st.text_input("Ask a question about the uploaded documents:")
        if user_question:
            docs = knowledge_base.similarity_search(user_question)
        
            llm = OpenAI()
            chain = load_qa_chain(llm, chain_type="stuff")
            with get_openai_callback() as cb:
                response = chain.run(input_documents=docs, question=user_question)
                print(response)
        
            # Save the content to file
            with open(response_file, 'w') as f:
                f.write(response)

            st.write(response)

            with open(response_file, 'rb') as f:
                st.download_button('Download', f, file_name=response_file)  # Defaults to 'application/octet-stream'

if __name__ == '__main__':
    main()