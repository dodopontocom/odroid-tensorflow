#!/bin/bash
#
BASEDIR=$(dirname $0)
source ${BASEDIR}/ShellBot.sh
bot_token=$(cat .token)
bot_version=$(tail -1 ${BASEDIR}/VERSION)

ShellBot.init --token "$bot_token" --monitor
ShellBot.username

while :
do
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
	
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
					
					msg="\`(version: $bot_version)\`\n"
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
						--text "$(echo -e "$msg")" \
						--parse_mode markdown
					msg="*Download da imagem realizado com sucesso.*\n\n"
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
						--text "$(echo -e "$msg")" \
						--parse_mode markdown
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
						--text "Processando, aguarde uns instantes..." \
						--parse_mode markdown

					message=$(docker run --rm -i -v ${PWD}:/home/tensor-photos tensorflow python /home/tensor-example.py "/home/tensor-photos/$(echo $file_path | cut -d'|' -f2 | sed 's#\.\/##')" > /tmp/usar_urandom.log)
					produto=$(tail -2 /tmp/usar_urandom.log | head -1)
					if [[ $? -eq 0 ]]; then
						elapsed="\`(tempo de processamento: $(tail -1 /tmp/usar_urandom.log) segundos)\`\n"
						ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
								--text "$(echo -e $elapsed)" \
								--parse_mode markdown
						ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
								--text "Produto: $(echo -e $produto)" \
								--parse_mode markdown
					else
						ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
								--text "Erro ao processar, tente outra imagem..." \
								--parse_mode markdown
					fi

					resultado=$(cat $imageLab | grep -i "$produto")
					if [[ ! -z $resultado ]]; then
						valor=$(cat $imageLab | grep -i "$produto:" | cut -d':' -f2)
						if [[ ! -z $valor ]]; then
							ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
									--text "Valor: $(echo ${valor})" \
									--parse_mode markdown
						else
							msg="Valor não registrado para o produto \`$produto\`"
							ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
									--text "$(echo -e ${msg})" \
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
