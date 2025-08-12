# GitHub Actions CI/CD Pipeline

## 🎯 Overview

Questo repository utilizza GitHub Actions per implementare un pipeline CI/CD completo con **protezioni di sicurezza**:

- **CI (Continuous Integration)**: Test automatici ad ogni push/PR
- **CD (Continuous Deployment)**: Deploy automatico su AWS **SOLO** se i test passano

## 📁 Workflows

### `ci-cd.yml` - Pipeline Completo con Protezioni
- **Trigger**: 
  - Push su `main`/`develop` 
  - PR verso `main`
  - Attivazione manuale
- **🔒 Vincoli di Sicurezza**:
  - **Deploy SOLO su branch `main`**
  - **Deploy SOLO se tutti i test passano** 
  - **Deploy SOLO su push (non su PR)**

#### Fasi del Pipeline:
1. **✅ FASE TEST**: Sempre eseguita
   - Test di integrazione con PostgreSQL
   - Controllo qualità del codice  
   - Security audit delle dipendenze
   
2. **🚀 FASE DEPLOY**: Solo se test OK + main branch
   - Deploy infrastruttura AWS con CDK
   - Deploy applicazione su EC2
   - Health check automatico
   - Notifiche di deployment

## 🔧 Setup Required

### GitHub Secrets
Configura questi secrets nel repository GitHub:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `EC2_PRIVATE_KEY` | SSH Private Key Content | `-----BEGIN RSA PRIVATE KEY-----\n...` |

### AWS Prerequisites
1. AWS CLI configurato localmente
2. CDK bootstrapped: `cdk bootstrap`
3. EC2 Key Pair creato: `aws ec2 create-key-pair --key-name aws-ec2-key`

## 🚀 Usage

1. **Push code to `develop`** → Runs tests
2. **Create PR to `main`** → Runs tests  
3. **Merge to `main`** → Runs tests + Deploy to AWS
4. **Manual deployment**: Go to Actions tab → Run workflow

## 🔍 Monitoring

- **Actions tab**: Vedi tutti i workflow runs
- **Deployments**: GitHub automatically tracks deployments
- **Health Check**: Automatic verification post-deployment

## 🛠️ Local Testing

Prima di fare push, testa localmente:

```bash
# Test in locale
npm start
npm test

# Deploy manuale (se necessario)
EC2_HOST=YOUR_IP ./scripts/deploy-to-ec2.sh
```

## 🚨 Troubleshooting

### Common Issues:

1. **AWS Credentials**: Verifica che i secrets siano configurati correttamente
2. **SSH Key**: Assicurati che il formato della private key sia corretto
3. **EC2 Ready**: Il workflow aspetta che EC2 sia pronto, ma potrebbe servire più tempo
4. **Security Groups**: Verifica che le porte 22 (SSH) e 3000 (app) siano aperte

### Debug Steps:
1. Controlla i logs nel tab Actions
2. Verifica lo stato delle risorse AWS nella console
3. Testa SSH connection manualmente se necessario