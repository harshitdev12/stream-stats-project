from flask import Flask, jsonify
from flask_cors import CORS
import random

app = Flask(__name__)
CORS(app) 

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200

@app.route('/api/stats', methods=['GET'])
def get_stats():
    
    return jsonify({
        "player": "harxit",
        "kills": random.randint(10, 30),
        "deaths": random.randint(5, 15),
        "assists": random.randint(2, 10),
        "current_rank": "Ascendant"
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)