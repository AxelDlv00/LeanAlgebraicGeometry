# Effort Breaker Report

## Slug
p1a

## Target
`lem:isQuasicoherent_restrict_basicOpen` (`AlgebraicGeometry.isQuasicoherent_restrict_basicOpen`)

## Status
COMPLETE — target re-expressed as a 3-lemma `\uses`-linked chain; top block now a short composition.

## Effort before → after
- target `effort_local`: 1741 → 1317
- sub-lemmas added: 3 (effort 699, 704, 1037 — each strictly smaller than the 1741 monolith)

## Chain added (target ← L3 ← L2 ← L1)
- `\label{lem:modules_restrict_basicOpen}` `\lean{AlgebraicGeometry.modulesRestrictBasicOpen}` (effort 699, deps 0) —
  **L1, the geometry primitive.** Restrict an `(Spec R).Modules` object `F` to `D(f)` and transport
  it across the canonical affine iso `D(f) ≅ Spec R_f` into a genuine `(Spec R_f).Modules` object,
  with comparison iso; functorial in `F`. No deps. SOURCE: lemma-widetilde-pullback + following remark.
- `\label{lem:tilde_restrict_basicOpen}` `\lean{AlgebraicGeometry.tilde_restrict_basicOpen}` (effort 704) —
  **L2, the widetilde-pullback identification.** `\widetilde{M}|_{D(f)} ≅ \widetilde{M_f}` over `Spec R_f`.
  `\uses{lem:modules_restrict_basicOpen}`. SOURCE: lemma-widetilde-pullback part (2) + its proof.
- `\label{lem:presentation_restrict_basicOpen}` `\lean{AlgebraicGeometry.presentation_restrict_basicOpen}` (effort 1037) —
  **L3, presentation/quasi-coherence transport under restriction.** A presentation of `F|_U` restricts
  to a presentation of `F|_{D(g)}` over `Spec R_g` for `D(g) ⊆ U`; hence `F|_{D(g)}` is quasi-coherent.
  `\uses{lem:modules_restrict_basicOpen, lem:tilde_restrict_basicOpen}`. SOURCE: lemma-quasi-coherent-affine proof.
- Target `lem:isQuasicoherent_restrict_basicOpen` proof rewritten to a short composition:
  `\uses{lem:exists_finite_basicOpen_subcover, lem:qcoh_iso_tilde_sections_of_presentation,
  lem:modules_restrict_basicOpen, lem:tilde_restrict_basicOpen, lem:presentation_restrict_basicOpen}`.
  Statement and `\lean{}` unchanged (frozen pin preserved). Verified via `archon dag-query ancestors`:
  full closure resolves, no broken `\uses`.

## Still hard (re-break candidates)
- `lem:presentation_restrict_basicOpen` (1037) is the heaviest new node — it carries two distinct
  sub-claims (restriction is additive + preserves free `\mathcal{O}`-modules; and the transport along
  `D(g) ≅ Spec R_g` sends free restricted modules to free `\widetilde{R_g}`-modules). If the
  mathlib-build prover stalls, re-dispatch the breaker at fine granularity to split it into
  (a) "restriction preserves right-exact free presentations" and (b) "restricted free module is free over `R_g`".
- `lem:modules_restrict_basicOpen` (699) genuinely bundles TWO Lean declarations the prover must build:
  the transported sheaf-of-modules `modulesRestrictBasicOpen` and a comparison iso (call it
  `modulesRestrictBasicOpenIso`). I noted this in the block's `% NOTE:`. Not split further — it is one
  mathematical step (the absent-from-Mathlib transport functor), but the prover should expect to
  scaffold both names.

## Could not decompose (strategy items)
- None. All three seams from the directive became sub-lemmas. The only open question (not mine to
  resolve) is whether the bare scheme-level iso `D(f) ≅ Spec R_f` is already a Mathlib re-export — I
  left it UNMARKED with a `% NOTE:` rather than guessing `\mathlibok` (loogle returned no hits for
  `basicOpen`/`Spec` iso patterns; could not confirm). A prover/review pass should resolve and, if it
  is a bare Mathlib anchor, mark it.

## References consulted
- `references/stacks-schemes.tex` L1241–1276 (lemma-widetilde-pullback statement + the remark "if you
  restrict the sheaf $\widetilde M$ to a standard affine open subspace $D(f)$, then you get
  $\widetilde{M_f}$") and L1262–1268 (its proof: `$\psi^{-1}(D(f)) = D(\psi^\sharp(f))$ … $=
  \widetilde{N_R}(D(f))$`) — verbatim onto L1, L2.
- `references/stacks-schemes.tex` L1287–1303 (lemma-quasi-coherent-affine proof: refine to standard
  open cover, get `$R_{f_i}$-modules $M_i$` and isos `$\varphi_i : \mathcal{F}|_{D(f_i)} \to
  \mathcal{F}_{M_i}$`) — verbatim onto L3 and the assembled top block.

## Notes for dispatcher
- `\lean{}` names I assigned by convention (confirm/scaffold for the next prover lane):
  `AlgebraicGeometry.modulesRestrictBasicOpen` (+ a comparison iso `modulesRestrictBasicOpenIso`),
  `AlgebraicGeometry.tilde_restrict_basicOpen`, `AlgebraicGeometry.presentation_restrict_basicOpen`.
- Build order for the prover lane: L1 (`modulesRestrictBasicOpen`, no deps) → L2 (`tilde_restrict_basicOpen`)
  → L3 (`presentation_restrict_basicOpen`) → top (`isQuasicoherent_restrict_basicOpen`).
- No new macros needed; all notation (`\widetilde`, `D(f)`, `(\operatorname{Spec} R).\mathrm{Modules}`)
  already in use in this chapter.
- Out-of-scope blocks (toSheaf family, `lem:tilde_preserves_kernels`, `def:affine_cover_system`) were
  not touched — left byte-stable.
- Did NOT add `\leanok` anywhere (sync_leanok's job). No `\mathlibok` added (the only candidate anchor,
  `D(f) ≅ Spec R_f`, is unconfirmed — left unmarked with a `% NOTE:`).
