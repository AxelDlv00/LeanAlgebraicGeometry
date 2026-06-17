# Blueprint-writer directive — iter-061

Chapter to edit (ONLY this file): `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

This is a cleanup + light-decomposition pass. The chapter is already complete and correct for
both active prover lanes; do NOT rewrite existing proof prose. Make exactly the four edits below.

## Strategy context (the slice that matters)
Two prover lanes run next iter against this chapter:
- Lane 1 closes CSI Stub 2 `lem:pushPull_sigma_iso` (the indexed disjoint-union module-sheaf
  decomposition `(q_p)_* (q_p)^* F ≅ ∏_σ (j_σ)_* (j_σ)^* F`). This is a ~200–400 LOC new-infra
  leaf; isolating the standalone disjoint-union iso as its own named sub-lemma gives the prover a
  clean intermediate build target.
- Lane 2 closes OpenImm `hqc` via `lem:pushforward_commutes_restriction` + `lem:pushforward_iso_preserves_qcoh`
  — already fully blueprinted; NO edit needed there.

## Edit 1 — add standalone sub-lemma `lem:pushPull_coprod_prod`
Immediately BEFORE `\begin{lemma}` of `lem:pushPull_sigma_iso` (around line 8006), insert a new
lemma block:
- `\label{lem:pushPull_coprod_prod}`
- `\lean{AlgebraicGeometry.pushPull_coprod_prod}`  (the Lean name the prover will create — it does
  not exist yet; this is a build target)
- `\uses{def:push_pull_obj, lem:coprodPresheafObjIso_mathlib, lem:isProductOfDisjoint_mathlib}`
- Statement: for a finite family of legs `(legs : ι → Over X)` (finite `ι`), the push–pull object
  on the coproduct `∐_i legs i` (structure map `Sigma.desc`) is the product of the per-leg push–pull
  objects: `pushPullObj F (Over.mk (Sigma.desc (fun i => (legs i).hom))) ≅ ∏_i pushPullObj F (legs i)`
  in `X.Modules`. Phrase it as the general indexed-coproduct→product disjoint-union module-sheaf iso
  (NOT tied to the σ-multi-index — that specialization is what `pushPull_sigma_iso` does).
- Proof block: lift the existing proof prose of `lem:pushPull_sigma_iso` lines 8037–8051 (reflect
  through `toPresheaf` faithful/reflects-iso/preserves-limits; binary `coprodPresheafObjIso` +
  `isProductOfDisjoint`; iterate over the finite index). Keep it textbook-rigorous.

Then EDIT `lem:pushPull_sigma_iso`:
- change its `\uses{}` (both the lemma-header and the proof `\uses`) to reference the new
  `lem:pushPull_coprod_prod` in place of the two Mathlib anchors, i.e.
  `\uses{def:push_pull_obj, lem:cech_backbone_left_sigma, lem:pushPull_coprod_prod}`.
- shorten its proof to: "By Lemma~\ref{lem:cech_backbone_left_sigma} the backbone `Y_p` is the
  coproduct `∐_σ U_σ` with structure map `q_p = Sigma.desc(σ ↦ j_σ)`; apply
  Lemma~\ref{lem:pushPull_coprod_prod} to this coproduct family." Keep the displayed equation.

## Edit 2 — clear coverage debt: bundle 2 CSI helper names into `lem:cech_backbone_left_sigma`
The Lean helpers `AlgebraicGeometry.coverInterProdIso` and `CategoryTheory.widePullbackBaseCongr`
were created in iter-060 and have no blueprint entry (leandag `unmatched`). Append both names to the
`\lean{...}` list of `lem:cech_backbone_left_sigma` (they are the σ-component identification and the
wide-fibre-power transport used in its proof). One line each is fine; do not add new lemma blocks.
Add a one-line note in the proof prose naming them if not already mentioned.

## Edit 3 — clear coverage debt: bundle 2 OpenImm helper names into `lem:jshriek_transport_along_iso`
The Lean helpers `AlgebraicGeometry.sectionsCorep` and `AlgebraicGeometry.sectionsCorepPushforward`
(iter-060, the two `CorepresentableBy` witnesses) have no blueprint entry. Append both names to the
`\lean{...}` list of `lem:jshriek_transport_along_iso`. Add a one-line proof-prose note: the iso is
`CorepresentableBy.uniqueUpToIso` applied to two corepresentability witnesses for the same
`sectionsFunctor (φ.inv⁻¹V) ⋙ forget` functor (the pushforward side via the adjunction, the direct
side via `jShriekOU_homEquiv`).

## Edit 4 — fix stale `\uses{}` on `lem:jshriek_transport_along_iso`
Its `\uses{}` currently lists `lem:compCoyonedaIso_mathlib, lem:coyoneda_fullyFaithful_mathlib`,
which the actual Lean proof does NOT use (it uses `CorepresentableBy.uniqueUpToIso`). Remove those
two refs from the `\uses{}`. Keep `def:jshriek_ou, lem:sectionsFunctorCorepIso`.

## Out of scope (do NOT touch)
- `lem:pushforward_commutes_restriction`, `lem:pushforward_iso_preserves_qcoh` — already complete.
- Any `\leanok` marker (managed by sync_leanok; never add/remove).
- Any other chapter or any `.lean` file.
