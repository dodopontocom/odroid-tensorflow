#!/bin/bash
#
BASEDIR=$(dirname $0)
source ${BASEDIR}/ShellBot.sh

# Token do bot
bot_token=$(cat .token)

# Inicializando o bot
ShellBot.init --token "$bot_token" --monitor
ShellBot.username

while :
do
	# Obtem as atualizações
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
	
	# Lista o índice das atualizações
	for id in $(ShellBot.ListUpdates)
	do
	# Inicio thread
	(
		# Desativa download
		download_file=0

		# Lê a atualização armazenada em 'id'
		if [ "${update_id[$id]}" ]; then
			[[ ${message_photo_file_id[$id]} ]] && file_id=${message_photo_file_id[$id]} && download_file=1
				[[ $download_file -eq 1 ]] && {
					dest_file=${BASEDIR}/
					imageLab=${BASEDIR}/ImageNetLabels.txt
					file_id=($file_id)
					getFile_id=$(echo ${file_id[@]} | cut -d'|' -f3)
					file_final=$(ShellBot.getFile --file_id "$getFile_id" | cut -d'|' -f4)
					file_path=$(ShellBot.downloadFile --file_path "${file_final}" --dir "$dest_file") && {
						msg="`(bot version: $(tail -1 $BASEDIR/VERSION))`"
						msg+="*Download do arquivo realizado com sucesso.*\n\n"

						ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e "$msg")" \
							--parse_mode markdown

						ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "Processando, aguarde uns instantes..." \
							--parse_mode markdown

						message=$(docker run --rm -i -v ${PWD}:/home/tensor-photos tensorflow python /home/tensor-example.py "/home/tensor-photos/$(echo $file_path | cut -d'|' -f2 | sed 's#\.\/##')")
						message=$(echo $message | cut -d'|' -f2)
						if [[ $? -eq 0 ]]; then
							ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
									--text "Produto: $(echo -e $message | cut -d'|' -f2)" \
									--parse_mode markdown
						else
							ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
									--text "Erro ao processar, tente outra foto..." \
									--parse_mode markdown
						fi

						resultado=$(cat $imageLab | grep -i $message)
						if [[ ! -z $resultado ]]; then
							valor=$(cat $imageLab | grep $resultado | cut -d':' -f2)
							if [[ ! -z $valor ]]; then
								ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
										--text "Valor: $(echo ${valor})" \
										--parse_mode markdown
							fi
						fi
					}
				}
		fi
	) &
	done
done
#end
