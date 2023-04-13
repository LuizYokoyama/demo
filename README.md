# Demo Jenkins pipeline with Flyway migrates and deploy on Minikube

Esta é uma demonstração de execução de uma pipeline do Jenkins que pega o código deste repositório git "***PULL***", aplica 
o migrates do Flyway no banco de dados Postgresql, constroi a aplicação com o Gradle, cria a imagem Docker, faz o "***PUSH***" 
desta imagem para o DockerHub e depois realiza o "***DEPLOY***" desta aplicação no Minikube.


## Passos para execução:

### 1º Instalar e inicializar o Minikube, Postgresql e o Jenkins

***Jenkins:***

O Jenkins pode ser instalado em um Docker, Kubernetes, Linux e vários outros sistemas.

Nesta demonstração será usado o Jenkins instalado no ***Linux***.

Mais informações sobre a instalação do Jenkins estão disponíveis na sua documentação oficial:

https://www.jenkins.io/doc/book/installing/

Para instalar o ***Jenkins*** no Linux ***Debian/Ubuntu***:

#### Executar: 

***sudo apt-get update***

***sudo apt-get install jenkins***

#### Instalação do Java:

Jenkins requer Java para rodar, mas certas  versões de Java são incompatíveis com Jenkins.

***sudo apt install openjdk-17-jre***



#### Iniciar Jenkins:

Você pode ativar o serviço Jenkins para iniciar na inicialização do sistema Linux com o comando:

***sudo systemctl enable jenkins***

Ou você pode iniciar o serviço Jenkins com o comando:

***sudo systemctl start jenkins***

Você pode verificar o status do serviço Jenkins usando o comando:

***sudo systemctl status jenkins***

Se tudo foi configurado corretamente, você deve ver uma saída como esta:

![img_20.png](img_20.png)

### 2º Acessar a pagina do Jenkins:
***http://localhost:8080/***

#### Adicionar credenciais no Jenkins:

http://localhost:8080/manage/credentials/

Clicar em:

![img.png](img.png)

Na tela que abrir, no seu canto superior direito, clicar em "+ Add Credentials":

![img_1.png](img_1.png)

Crie uma credencial com o ***ID*** "*postgres*" do tipo "***Username with password***", com seus respectivos username e password,
para que o executor do pipeline possa acessa-lo;

Crie uma credencial com o ***ID*** "*login_DockerHub*" do tipo "***Username with password***", com seus respectivos username e password,
para que o executor do pipeline possa acessa-lo;

Ao criar uma credencial com o ***ID*** "*Kubernetes*" do tipo "***Kubernetes configuration (kubeconfig)***", 
em "***Kubeconifig***", click em "***Enter directly***":

![img_2.png](img_2.png)

Depois para poder preencher o ***Content***, 

![img_4.png](img_4.png)

vá ao terminal de comandos do linux, vizualize o conteúdo do arquivo ***config*** do **minikube**,
geralmente encontrado no diretório: /home/*{seu usuário}*/.kube

![img_3.png](img_3.png)

Copie este conteúdo do arquivo config e cole no o ***Content***.

Ainda no ***Content***,
altere ***certificate-authority*** para ***certificate-authority-data*** e substitua o caminho do arquivo de certificado
"*/ca.cr" pelo seu conteúdo codificado em base64.

No terminal dp Linux execute o comando para obter este conteúdo codificado em base64: 

***cat "certificate file" | base64***

Repita o mesmo procedimento:

Altere ***client-certificate*** para ***client-certificate-data*** e digite a string codificada em base64 do arquivo de certificado */client.crt;

Altere ***client-key*** para ***client-key-data*** e digite a string codificada em base64 do arquivo de certificado*/client.key.


O resultado deve ficar assim:

![img_5.png](img_5.png)


### Adicionar a extensão Flyway Runner:

Acesse o gerenciador de extensões do Jenkins:

http://localhost:8080/manage/pluginManager/

Localize e instale o Flyway Runner:

![img_6.png](img_6.png)

Localize e instale o Gradle:

![img_19.png](img_19.png)

***Talvez seja necessária a instalação mais alguma extensão do Docker, DockerHub, Git, GitHub...!***

No caso de falha na execução da Pipiline do Jenkins, talvez tenha que instalar a extensão correspondente.

### Configurar o Jenkins:

http://localhost:8080/manage/configure

Em ***GitHub*** adicione um ***GitHub Server***:

![img_7.png](img_7.png)


### Configurar ferramentas de Configuração Global:

http://localhost:8080/manage/configureTools/

Localize o Gradle na página acima e adicione esta versão:

![img_8.png](img_8.png)

Localize o Flyway e adicione exatamente esta versão:

![img_9.png](img_9.png)


### Clonar este repositório

Clonar este repositório será preciso somente caso aja necessidade e alterar algum arquivo, como o ***Jenkinsfile***.


### Criar uma nova Pipeline no Jenkins


Na página inicial do Jenkins, click em "***+ Nova tarefa***":

![img_10.png](img_10.png)

Depois coloque um nome para a tarefa, escolha Pipeline e depois click no botão Tudo certo:

![img_11.png](img_11.png)

![img_12.png](img_12.png)

Em GitHub project, insira a url deste repositório ou a do seu próprio repositório:

![img_13.png](img_13.png)

Em ***Pipeline > Definition*** escolha ***Pipelline script from SCM*** e preencha assim:

![img_14.png](img_14.png)

Em ***Pipeline > Script Path*** preencha com Jenkinsfile, para este arquivo do repositório ser usado na pipeline:

![img_15.png](img_15.png)


### Ajustes no Jenkinsfile

Podem ser necessários alguns ajustes no Jenkinsfile, como por exemplo os IDs de credenciais ou o URL do postgres:

![img_16.png](img_16.png)

### Executando a pipeline do Jenkins

Por último, basta clicar em construir agora:

![img_17.png](img_17.png)

Se tudo der certo, poderá ser possível ver a pipeline executando:

![img_18.png](img_18.png)