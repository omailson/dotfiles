#!/usr/bin/env python2
# -*- encoding: UTF-8 -*-

import calendar
import xml.dom.minidom
import re
import datetime
import glob

meses = ['Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro']

anoHoje = datetime.date.today().year
mesHoje = datetime.date.today().month
ano = raw_input('Digite o ano [%d]:' % (anoHoje))
if ano.isdigit():
    ano = int(ano)
else:
    ano = anoHoje
mes = raw_input('Digite o mês [%d]:' % (mesHoje))
if mes.isdigit():
    mes = int(mes)
else:
    mes = mesHoje

listaDeArquivos = glob.glob('*.svg')
if len(listaDeArquivos) == 0:
    arquivo = raw_input('Digite o nome do arquivo de origem: ')
else:
    i = 0
    print 'Escolha o arquivo de origem: '
    for j in listaDeArquivos:
        i = i + 1
        print i, j
    arquivo = listaDeArquivos[input('Escolha: ') - 1]


calendar.setfirstweekday(calendar.SUNDAY)
calendario = calendar.monthcalendar(ano, mes)

dom = xml.dom.minidom.parse(arquivo)

pattern = re.compile("s([1-6])d([1-7])")

for nos in dom.getElementsByTagName('text'):
    mat = pattern.match(nos.attributes["id"].value)
    if nos.attributes["id"].value == 'mes':
        nos.firstChild.firstChild.data = meses[mes - 1]
    elif nos.attributes["id"].value == 'ano':
        nos.firstChild.firstChild.data = ano
    elif mat != None:
        s = int(mat.group(1)) - 1
        d = int(mat.group(2)) - 1
        if s < len(calendario):
            if calendario[s][d] == 0:
                nos.firstChild.firstChild.data = ''
            else:
                nos.firstChild.firstChild.data = calendario[s][d]
        else:
            nos.firstChild.firstChild.data = ''

arquivoDestino = raw_input('Digite o nome do arquivo de destino: ')
handleDestino = open(arquivoDestino, 'w')
handleDestino.write(dom.toxml().encode('UTF-8'))
handleDestino.close()
print 'Salvo!'
