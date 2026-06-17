Target: blueprint/src/chapters/Picard_FlatteningStratification.tex

Action: clear DAG coverage-debt flagged by the iter-058 blueprint review (chapter is `complete:false` only because of missing coverage blocks on already-proved helpers; the flatV route prose is already complete+correct). Do ALL of:

1. ADD lemma block `lem:gf_stalk_flat_localBase`, `\lean{AlgebraicGeometry.gf_stalk_flat_localBase}`, `\uses{lem:mathlib_localization_flat, lem:mathlib_flat_trans}`. Statement: for a scalar tower `A → Localization.Away f → M` with `M` flat over `Localization.Away f`, and the localization map flat, `M` is flat over the local base — i.e. flatness transports along the localization tower (`IsLocalization.flat` + `Module.Flat.trans`). Proved axiom-clean in Lean (`.lean:2746`). One-line informal proof: compose `IsLocalization.flat` with `Module.Flat.trans`.

2. ADD a `\mathlibok` Mathlib-dependency anchor for `Module.free_of_isLocalizedModule` (`\lean{Module.free_of_isLocalizedModule}`), stating: a localized module of a free module at a submonoid is free over the localized ring. Used at `.lean:3083,3176,3275`.

3. WIRE `\uses{lem:mathlib_flat_localization_preserves}` into the PROOF block of `lem:gf_flat_localizedModule_sameBase` (it is `\cref{}`-cited in the lemma prose at line ~1936 but absent from `\uses{}`).

Constraints: additive only — do NOT alter the flatV/genericFlatness route prose. Do NOT add `\leanok` (sync_leanok owns it). `\mathlibok` ONLY on the genuine Mathlib anchor in item 2. Keep verbatim source quotes intact. If a new source quote is needed, you may spawn reference-retriever (references/** authorized).
