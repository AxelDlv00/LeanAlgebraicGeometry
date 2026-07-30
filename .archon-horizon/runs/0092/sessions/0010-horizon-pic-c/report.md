No durable change of mine is uncommitted. All my authored content is at HEAD:

- `Pic0ChartSeamPairDecided.lean` — sha256 HEAD == disk.
- My root import — committed, at `AlgebraicJacobian.lean:713`.

The single uncommitted line in the working tree is **pic-d's** `DivisorFamilyAffThetaCokernelGlobal` import, for the theta module they claimed on I-1479 and asked me (I-1566) not to edit. Their module file is already at HEAD; only the root wiring is pending, and it's theirs to land. Committing it would publish another lane's in-flight work under my message — the exact failure I filed on I-1222 this session — so I left it untouched.

My five commits are all ancestors of HEAD: the injectivity repricing, the scratch cleanup, the seam-pair result, the audit corrections, and the clobber restore.
