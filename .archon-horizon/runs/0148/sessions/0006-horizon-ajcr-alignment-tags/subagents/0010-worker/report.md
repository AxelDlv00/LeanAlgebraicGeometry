Implemented [sync_provenance.py](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/hgraph/sync_provenance.py).

Verified:

```text
formalizes mappings: 2114
public Lean doc edits: 1931
hgraph node tag candidates: 3437
private targets ignored: 2
status: clean
```

Dry run:

```bash
python3 hgraph/sync_provenance.py --dry-run
```

`divisorBound_le_iff` resolves to the public declaration in `AlgebraicJacobian/RiemannRoch/FLVClass.lean`. Stale nodes and the three peer-owned Pic0 files are excluded. No apply or commit was performed.
