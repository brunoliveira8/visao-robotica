%function [imagem] = aquisicao_imagem1()
clear all
close all
clc

% Importar bibliotecas java
pasta = [pwd '/lib/']; %Pasta 'lib' deve se encontrar no mesmo diretorio deste arquivo
javaaddpath([pasta 'commons-logging-1.1.jar']);
javaaddpath([pasta 'ws-commons-util-1.0.2.jar']);
javaaddpath([pasta 'xmlrpc-client-3.1.3.jar']);
javaaddpath([pasta 'xmlrpc-common-3.1.3.jar']);
javaaddpath([pasta 'xmlrpc-server-3.1.3.jar']);       

import org.apache.xmlrpc.*


ip_sensor = '192.168.0.69'; %IP do sensor com quem sera feita a comunicacao
% Atribuicao de variaveis Java
client_xmlrpc = javaObject('org.apache.xmlrpc.client.XmlRpcClient');
config = javaObject('org.apache.xmlrpc.client.XmlRpcClientConfigImpl');
url = javaObject('java.net.URL', strcat('http://',ip_sensor,':8080'));
config.setServerURL(url);
client_xmlrpc.setConfig(config);

% Configuracao do cliente Socket
client_socket = tcpip(ip_sensor, 50002,'InputBufferSize',13176,'ReadAsyncMode', 'continuous');
configurar_sensor(client_xmlrpc); %Configuracoes do sensor
% client_socket = tcpip(ip_sensor, 50002,'InputBufferSize',13176,'ReadAsyncMode', 'continuous');

fopen(client_socket); %Abre cliente Socket


% Modo de captura da imagem
modo='Z'; %Imagem de distancia. 'D' maiúsculo para sincronizar com a primeira imagem do frame atual do sensor


%while(1) %Utilizado para aquisicao continua da imagem
client_xmlrpc.execute('MDAXMLHeartbeat', []); %Sinal de heartbeat para manter a conexao com o sensor
fwrite(client_socket,modo); %Envia ao servidor Socket o modo de imagem. É a funcao responsável por solicitar a imagem.

resposta = get(client_socket, 'BytesAvailable'); %Analisa quantos bytes estao disponiveis para leitura
while(resposta~=13176) %13175 bytes correspondem a uma imagem completa (header + dados)
    fwrite(client_socket,modo);                      %|Enquanto a resposta nao estiver completa,
    resposta = get(client_socket, 'BytesAvailable'); %|nao avanca para a proxima parte.
end


V = fread(client_socket, 3294,'float'); %Faz a leitura de todos os 3294 floats = 13175 bytes
    
h = V(1:94,1); %Obtem o header da mensagem

%% Obtencao e exibicao da imagem
img = V(95:end,1); %Obtem o restante da mensagem (que corresponde a imagem)
imagem = zeros(64,50); %Imagem na forma matricial, inicializada com zeros
k=1;
for j=1:50
    for i=1:64
        imagem(i,j) = img(k,1); %Aloca a mensagem nos pixels na forma matricial
        k=k+1;
    end
end

%imshow(imagem, []);
% try
%     ident_obj1(imagem);
% catch 
%     disp('Objeto não identificado.')
% end

% save('img_Y', 'Y')
    

fclose(client_socket); %Encerra comunicacao com o Socket
% encerrar_conexao(client_socket,client_xmlrpc);

