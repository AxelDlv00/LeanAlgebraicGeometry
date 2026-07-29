Sent to the coordinator. The audit was already complete, so nothing was cut short.

## VERDICT: CONFIRMED in substance, OVERSTATED in wording. One collateral claim in the same commit is REFUTED.

All measurements at HEAD; disk blobs match HEAD for both files (`ef88f3eb16…`, `8b0bd12592…`).

### The two types

`hcpt` — /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AtlasFiniteType.lean:276 (repeated :381):
```
(hcpt : CompactSpace (Scheme.LocalRepresentability.glueData hf).glued)
```
The field — /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianData.lean:100:
```
  quasiCompact : QuasiCompact J.hom
```

Not definitionally equal. `example (h : QuasiCompact (gluedHom C f hf)) : CompactSpace (glueData hf).glued := h` gives `Type mismatch`; `Iff.rfl` for the iff fails. Interderivable via `HasAffineProperty.iff_of_isAffine` (mathlib Morphisms/Basic.lean:577, needs `[IsAffine Y]`, supplied by the affine base). `JacobianData` has exactly four fields, so "not a fifth obligation" is correct on the count.

### What genuinely supports the claim, stronger than the file argues

At the atlas carrier `hcpt`'s only consumer is that field slot: `(JacobianData.ofChartsOfCompactSpace C f hf hlft hcpt).quasiCompact = HasAffineProperty.iff_of_isAffine.mpr hcpt` closes by `rfl`. The iff is fully generic — it closes for an arbitrary `J`, nothing atlas-specific. And route-independence, which the file never checks: for any two `pic0TypeFunctor C` representations, `QuasiCompact J'.hom → QuasiCompact J.hom` via `uniqueUpToIso` + `Over.w`. That last fact is what actually licenses "one obligation between two rows".

### File status and net effect

Pic0AtlasCompactFromClass.lean: zero diagnostics, six declarations, all axiom-clean `[propext, Classical.choice, Quot.sound]`; control `#print axioms AlgebraicGeometry.Jacobian` does fire `sorryAx`. `gluedOfCharts_left_eq_glued` is genuinely `rfl`. `compactSpace_of_finite_atlas` is not new content — one line from the pre-existing `quasiCompact_gluedHom` (JacobianDataCharts.lean:164) plus the new iff.

No obligation vanished. The `hcl` shape occurs 11 times, every one in hypothesis position, none concluded. Both rows still exist and are uncross-referenced (`inbox_refs` empty): `atlas-hcpt` active/ajcr-p4, `dat-j.qcfield` pending/unowned. Still open: the `quasiCompact` field at any `pic0` representation — `dat-j.qcfield`'s owner discharges it, and atlas `hcpt` is then free.

### Refuted collateral

Pic0AtlasCompactFromClass.lean:290-292 calls per-chart compactness and `Finite ι` "both free at the divisor-representability carrier". Charts are `↥(V i)`, opens of `(D i).left` (Pic0ChartAtlasParamFree.lean:86-94); with `[∀ i, CompactSpace (D i).left]` in scope, `CompactSpace ↥(V i)` fails to synthesize. `Finite ι` is free at no carrier. This runs against the file's own contrast argument rather than propping it up.

I-1132's "four open inputs" also omits the explicit `lam` argument and the section data `Y, A, B, g, r₁, r₂, b₁, b₂`.

### Could not measure

No `lake build`, so I-1132's "8913 jobs, EXIT=0" is unverified by me — LSP elaboration is clean and the iff resolved by name, so no stale-olean trap. Roadmap `summary` fields for both rows are empty; I compared titles only.
