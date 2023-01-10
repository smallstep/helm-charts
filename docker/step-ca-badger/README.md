# step-certificates-badger

Image for backup/restore of Badger database running inside step-certificates pod.

# Usage

## Configuration

Add init-container to step-certificates Statefulset:
```
- name: {{ .Chart.Name }}-backuprestore
  image: {{ .Values.image.backupRestoreRepository }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  command: ["/usr/local/bin/backup-restore.sh" ]
  volumeMounts:
  - name: database
    mountPath: /home/step/db
    readOnly: false
```

## Backup

The init-container does a back-up of the Badger database every time the pod restarts. Note, Badger backup/restore does not operate on a database in use.

The backup can be extracted by use of for example `kubectl cp <pod>:/home/step/db/backup/badger-db.bak badger-db.bak  -c step-certificates -n <namespace>` or by using Kubernetes CSI `VolumeSnapshot`.

A Kubernetes job or similar cronjob can schedule restart of the pod.

## Restore

Copy a backup file into the folder `/home/step/db/restore/badger-db.bak` inside the step-certicates pod and then restart the pod.
The init-container will take a backup of the existing database, remove existing database (all files in `/home/step/db`) and then restore the database.


