function [frontData] = configurar_sensor(client_xmlrpc)

% client_xmlrpc.execute('MDAXMLConnectCP', [javaObject('java.lang.String','192.168.0.10') javaObject('java.lang.Integer',0)]);
client_xmlrpc.execute('MDAXMLConnectCP', [ ])
% método para verificar parâmetros de rede
% client_xmlrpc.execute('MDAXMLGetNetworkParams',javaObject('java.lang.String','http://192.168.0.10'));
%comando para programar o modo de trabalho
% client_xmlrpc.execute('MDAXMLGetTrigger', [javaObject('java.lang.Integer',0) javaObject('java.lang.Integer',0) javaObject('java.lang.Integer',3)]);

client_xmlrpc.execute('MDAXMLSetProgram', [javaObject('java.lang.Integer',0) javaObject('java.lang.Integer',0) javaObject('java.lang.Integer',7)]);

% configurar trigger
confTrigger = 3; %3 para trigger automático e 4 para trigger por software
client_xmlrpc.execute('MDAXMLSetTrigger',[javaObject('java.lang.Integer',0) javaObject('java.lang.Integer',0) javaObject('java.lang.Integer',confTrigger)]);

client_xmlrpc.execute('MDAXMLSetWorkingMode', javaObject('java.lang.Integer',1));

% client_xmlrpc.execute('MDAXMLGetFrontendData', javaObject('java.lang.Integer',0))
arg0 = javaObject('java.lang.Integer',0);
arg1 = javaObject('java.lang.Integer',0);
arg2 = javaObject('java.lang.Integer',1);
arg3 = javaObject('java.lang.Integer',0);
arg4 = javaObject('java.lang.Integer',1500);
arg5 = javaObject('java.lang.Integer',2000);
arg6 = javaObject('java.lang.Integer',20);
arg7 = javaObject('java.lang.Integer',141);
frontData = client_xmlrpc.execute('MDAXMLSetFrontendData', [arg0 arg1 arg2 arg3 arg4 arg5 arg6 arg7]);