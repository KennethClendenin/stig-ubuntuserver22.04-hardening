# [Ubuntu Server 22.04 STIG Bash Hardening Scripts](https://github.com/KennethClendenin/stig-ubuntuserver22.04-hardening/tree/main/scripts)

This repository contains Bash scripts developed to implement specific Ubuntu Server 22.04 security controls, based on guidance from [STIGAVIEW](https://stigaview.com/), which references DISA STIGs (Security Technical Implementation Guides - V2R4).

Each script focuses on a single control, uses a modular structure, and includes optional toggles for lab testing or demonstration purposes.

🎯 **Purpose:** Automate the application of STIG control implementations in Ubuntu Server 22.04 environments using auditable, maintainable, and enterprise-ready Bash scripts.

---

### 🔄 Additional Automation Scripts

This repository also includes two helper scripts designed to simplify workflow and support batch operations:

#### `batchUpdateFiles.sh`
Downloads a predefined list of STIG control scripts directly from the GitHub repository using `curl -O`, and ensures each file is made executable using `chmod +x`. Useful for syncing scripts across lab environments or fresh VMs.

```bash
sudo ./batchUpdateFiles.sh
```

#### `batchRunner.sh`
Executes all executable scripts in the current directory (excluding itself and other defined exclusions) and passes a single boolean argument (`true` or `false`) to each one. This supports batch applying or reverting of all available STIG controls in a single run.

```bash
sudo ./batchRunner.sh true    # Apply all controls (compliant)
```
```bash
sudo ./batchRunner.sh false   # Revert all controls (non-compliant)
```

---
> ⚠️ **Disclaimer**  
> These scripts are intended for use in a lab or an approved enterprise environment. Always validate changes in a test environment before deploying to production. Implementation should align with your organization’s compliance policies and change management practices.
---

