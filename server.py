from flask import Flask, redirect
from flask import send_file
import os

app = Flask(__name__)

@app.route('/Google_Sat_RU_SD/<path:subpath>')
def hello_world(subpath):
    z,y,x = subpath.split("/")
    x = x[:-4]
    path = "d:/карты/Google_Sat_RU_SD/z{}/{}/{}.jpg".format(z,x,y)
    return send_file(path)

if __name__ == "__main__":
    app.run(debug=False)
