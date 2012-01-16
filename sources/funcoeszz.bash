# Instalacao das Funcoes ZZ (www.funcoeszz.net)
export ZZOFF=""  # desligue funcoes indesejadas
export ZZPATH="/usr/bin/funcoeszz"  # script
if [ -f $ZZPATH ]
then
	source "$ZZPATH"				
fi
