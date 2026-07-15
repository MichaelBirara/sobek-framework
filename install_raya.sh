#!/bin/bash
# ==============================================================================
# SOBEK UNIVERSAL DECENTRALIZED SYSTEM FRAMEWORK - PURE CORE INSTALLER
# ==============================================================================
# Aim: Build a server-free system framework that sits cleanly on top of SQLite.

set -e

RAYA_VERSION="1.0.0-CORE"
SQLITE_YEAR="2026"
SQLITE_VERSION="3530300" 

echo "================================================================================"
echo "    INITIALIZING PURE SOBEK FRAMEWORK ENGINE (v$RAYA_VERSION)                    "
echo "================================================================================"

# 1. Create clean workspace directories
mkdir -p sobek_core/build
mkdir -p sobek_core/extensions

# 2. Fetch the upstream SQLite Amalgamation source code natively
echo "[*] Pulling upstream SQLite core binaries..."
SQLITE_URL="https://sqlite.org/${SQLITE_YEAR}/sqlite-amalgamation-${SQLITE_VERSION}.zip"

if ! command -v curl &> /dev/null; then
    echo "[-] Error: curl is required to pull the source code bedrock."
    exit 1
fi

curl -sL "$SQLITE_URL" -o sobek_core/build/sqlite.zip

# Unpack SQLite source directly into the build environment
echo "[+] Unpacking embedded storage layer..."
cd sobek_core/build
unzip -q -o sqlite.zip
mv sqlite-amalgamation-${SQLITE_VERSION}/* .
rm -rf sqlite-amalgamation-${SQLITE_VERSION} sqlite.zip
cd ../..

# 3. Create the clean, empty framework boot hook
echo "[*] Injecting clean SOBEK framework initialization hooks..."
cat << 'INNER_EOF' > sobek_core/extensions/sobek_init.py
import sqlite3
import os

DB_NAME = "sobek_system.db"

def initialize_sobek_framework():
    """Initializes a clean, blank system database for the framework environment."""
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute("PRAGMA foreign_keys = ON;")
    
    # Core Framework Registries (Empty Infrastructure for Developers)
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS system_applications (
            app_id INTEGER PRIMARY KEY AUTOINCREMENT,
            app_name TEXT UNIQUE NOT NULL,
            category TEXT NOT NULL,
            code_hash TEXT UNIQUE NOT NULL,
            version TEXT NOT NULL
        );
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS distributed_ledger (
            record_id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            state_data TEXT NOT NULL,
            cryptographic_signature TEXT UNIQUE NOT NULL
        );
    ''')
    
    conn.commit()
    conn.close()
    print("[SOBEK CORE] Clean system database architecture deployed successfully.")

if __name__ == "__main__":
    initialize_sobek_framework()
INNER_EOF

# 4. Finalize upstream references
mv sobek_core/build/sqlite3.c sobek_core/build/sqlite3_base_upstream.c
cp sobek_core/build/sqlite3_base_upstream.c sobek_core/build/sqlite3.c

# Run the initializer to establish the blank system db out-of-the-box
python3 sobek_core/extensions/sobek_init.py

echo ""
echo "================================================================================"
echo " [+] SOBEK FRAMEWORK IS UNIFIED WITH SQLITE AND READY FOR RELEASE                 "
echo "================================================================================"
echo " -> Clean storage engines initialized."
echo " -> Ready for open distribution on GitHub."
echo "================================================================================"
