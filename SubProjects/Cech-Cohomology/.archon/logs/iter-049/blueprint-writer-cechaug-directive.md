# Blueprint-writer directive — align `lem:cech_augmented_resolution` proof sketch (stalk-at-prime)

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Scope — EXACTLY ONE block
Rewrite ONLY the `\begin{proof} ... \end{proof}` of `\label{lem:cech_augmented_resolution}`
(`\lean{AlgebraicGeometry.cechAugmented_exact}`, currently ~lines 6826–6842). Do NOT touch the
statement block, its `% SOURCE`/`% SOURCE QUOTE` comments, or any other block in the chapter.

## Why
The blueprint reviewer (iter-049) flagged a **soon-severity** proof-sketch gap: the current sketch
says "over a refinement on which the cover restricts to a standard cover `U = ⋃ D(fᵢ)`" but does
NOT name the lemma giving that refinement, and the cover elements `Uᵢ ∩ U` need not be basic opens
of `U = Spec A`. The Stacks source quote already present in the block uses the cleaner
**stalk-at-prime / localize-at-a-prime** criterion. Align the informal proof with that approach so
the prover formalizes along the reliable path.

## Required new proof sketch (mathematical content to convey — project notation)
Exactness of a complex of sheaves of `O_X`-modules is a **local question**: a complex is exact iff
it is exact on every stalk (equivalently, after localizing the sections at every prime). So it
suffices to check exactness of the augmented Čech complex stalkwise.

Fix an affine open `U = Spec A` of `X` and a prime `𝔭 ∈ Spec A`. By the affine tilde isomorphism
(`lem:qcoh_iso_tilde_sections`, now unconditional via `lem:qcoh_isIso_fromTildeGamma`), `F|_U ≅ ~M`
with `M = Γ(U, F)`, and the sections of `~M` over the faces are the away-localizations
`M_{g_σ}`. The stalk/localization of the augmented Čech complex at `𝔭` is therefore the localization
at `𝔭` of the extended complex of localizations
`0 → M → ∏_{i₀} M_{f_{i₀}} → ∏_{i₀i₁} M_{f_{i₀}f_{i₁}} → ⋯`.

Since the `{f_i}` cover `Spec A`, for the prime `𝔭` there is an index `i` with `f_i ∉ 𝔭`, i.e. `f_i`
becomes a **unit** in `A_𝔭`. The standard "one index is a unit" contracting homotopy
`h(s)_{i₀…i_p} = s_{i i₀…i_p}` then witnesses exactness of the localized extended complex in every
positive degree and at the augmentation — this is exactly the standard-cover Čech vanishing already
proved at section level in the project, `lem:cech_acyclic_affine`
(`AlgebraicGeometry.sectionCech_affine_vanishing`, P3, via the prime-local span certificate
`exact_of_isLocalized_span`). As this holds for every prime `𝔭` (hence every stalk), the augmented
Čech complex is exact on `X`; i.e. the Čech nerve (`def:cech_nerve`) is a resolution of `F` in
`QCoh(X)`.

Keep the `\uses{def:cech_nerve, lem:cech_acyclic_affine, lem:qcoh_iso_tilde_sections}` on the proof
block (these are the genuine dependencies). Do NOT add `\leanok`.

## Citation discipline
The block ALREADY carries the verbatim `% SOURCE QUOTE:` from `references/stacks-coherent.tex`
(L68–82): "It suffices to show that (extended) is exact after localizing at a prime 𝔭, see Algebra,
Lemma characterize-zero-local." Your rewritten prose must be consistent with that quote (stalk/prime
localization). If you need any additional verbatim source text from `references/stacks-coherent.tex`
to support the "one f_i is a unit ⟹ contracting homotopy" step (Algebra `lemma-cover-module`),
read it locally and you MAY add a `% SOURCE QUOTE PROOF:` fragment — but do not fabricate; only quote
what you actually read.

## Out of scope
- The statement block, all other lemmas, all `\lean{}`/`\mathlibok`/`\leanok` markers.
- The 2 cosmetic `\uses` items on `lem:qcoh_isIso_fromTildeGamma` (handled separately by review).

Report what you changed to `task_results/blueprint-writer-cechaug.md`.
