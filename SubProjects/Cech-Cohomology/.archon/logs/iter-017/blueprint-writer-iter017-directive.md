# Blueprint-writer directive — chapter `Cohomology_CechHigherDirectImage.tex`

You edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (and, if you must fetch a
source you lack, you may spawn a reference-retriever into `references/**`). Do NOT add or remove any
`\leanok` marker (the deterministic `sync_leanok` phase owns it). You MAY edit `\lean{...}` lists,
prose, `\uses{...}`, and add new blocks.

This chapter is the consolidated blueprint for four Lean files
(`CechHigherDirectImage.lean`, `CechAcyclic.lean`, `PresheafCech.lean`, `FreePresheafComplex.lean`).
A new fifth file `CechBridge.lean` is being created this iter (a refactor agent scaffolds it in
parallel). All five are covered by the `% archon:covers` lines at the top of the chapter.

Five tasks. All are corrections/additions to make the blueprint match what the iter-016 provers
actually built (the Lean is correct and axiom-clean; the prose lagged) and to ready three prover
lanes (L1 bridge, free-complex quasi-iso, hom-identification).

---

## TASK 1 — Reconcile the section/hom-id target category to ABELIAN GROUPS (Ab), not O_X(U)-modules

The iter-016 prover built `sectionCechComplex` as `CochainComplex Ab ℕ` (abelian groups), which is
exactly what the Stacks source you already quote says ("This is an abelian group"), and is what the
Hom-complex `Hom_{PMod}(K_•, F)` naturally is. The prose currently says "O_X(U)-modules", which is
wrong. Fix both blocks:

1. `def:section_cech_complex` (around L797): change the prose "cochain complex of
   $\mathcal{O}_X(U)$-modules" to "cochain complex of **abelian groups**", and the closing sentence
   "an object of $\mathcal{O}_X(U)$-modules" to "an object of abelian groups (the underlying
   additive structure of the sections)". Remove the `% NOTE: [iter-016 review] ...` comment lines
   (now resolved). Keep the Stacks SOURCE QUOTE intact.

2. `lem:cech_complex_hom_identification` (around L861): change "isomorphism of cochain complexes of
   $\mathcal{O}_X(U)$-modules" to "isomorphism of cochain complexes of **abelian groups**" in BOTH
   the statement paragraph (L883) and anywhere the proof says O_X(U)-modules. Remove the
   `% NOTE: [iter-016 review] ...` comment lines. Add a sentence to the proof noting the per-multi-index
   bijection `freeYonedaHomEquiv` is promoted to an `AddEquiv` (`freeYonedaHomAddEquiv`) and the
   complex isomorphism is assembled in Ab via `HomologicalComplex.Hom.isoOfComponents`.

The Lean home of `cechComplex_hom_identification` is the NEW file `CechBridge.lean` (it needs both
the section complex from `PresheafCech.lean` and the free complex from `FreePresheafComplex.lean`,
and the import direction forces it downstream of both). No prose change is needed for that fact, but
keep the `\lean{AlgebraicGeometry.cechComplex_hom_identification, ...}` pin as-is (name unchanged).

---

## TASK 2 — Add a definition block for the augmentation object O_𝒰 (needed by the quasi-iso lane)

`lem:cech_free_complex_quasi_iso` concludes `H_0(K_•) = O_𝒰`, but there is no standalone definition
block for `O_𝒰`, so the prover building the quasi-iso has no `\lean{}` pin to construct against. Add a
new `\begin{definition}` block IMMEDIATELY BEFORE `lem:cech_free_complex_quasi_iso` (i.e. after the
`def:section_cech_complex`/`lem:cech_complex_hom_identification` group, before L951):

- `\label{def:cover_structure_presheaf}`
- `\lean{AlgebraicGeometry.coverStructurePresheaf}`
- `\uses{def:cech_free_presheaf_complex}`
- Title: "[The cover structure presheaf $\mathcal{O}_\mathcal{U}$]"
- SOURCE: reuse the Stacks `lemma-homology-complex` quote already present at L959-961
  (`$\mathcal{O}_\mathcal{U} \subset \mathcal{O}_X$ ... image presheaf of
  $\bigoplus j_{p!}\mathcal{O}_{U_i} \to \mathcal{O}_X$`) — read it from
  `references/stacks-cohomology.tex` and quote verbatim with the mandatory `% SOURCE:` /
  `% SOURCE QUOTE:` / visible `\textit{Source: ...}` lines.
- Prose: `O_𝒰 : X.PresheafOfModules` is the image presheaf of the augmentation
  `∐_i freeYoneda(U_i) → unit` (= `PresheafOfModules.unit X.ringCatSheaf.obj`, the structure presheaf
  O_X as a presheaf of modules), so `O_𝒰(W) = O_X(W)` when W is contained in some U_i and 0
  otherwise. State that `def:cech_free_presheaf_complex`'s degree-0 term `K_0 = ∐_i freeYoneda(U_i)`
  carries the augmentation map `K_0 → O_𝒰`.

Then update `lem:cech_free_complex_quasi_iso`:
- add `def:cover_structure_presheaf` to its `\uses{...}` (both statement and proof `\uses`).
- The Lean shape is the prover's design choice; state the lemma flexibly: "the augmented complex
  `… → K_1 → K_0 → O_𝒰 → 0` is exact (equivalently `K_•` is a resolution of `O_𝒰[0]`), so the
  augmentation `K_• → O_𝒰[0]` is a quasi-isomorphism." Keep `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}`.
- Append a sentence to the proof referencing the validated route: homology of a presheaf-of-modules
  complex is computed sectionwise because `PresheafOfModules.evaluation … V` preserves homology
  (`inferInstance`); the contracting homotopy is the prepend-`i_fix` map, the SAME combinatorial
  content as `CombinatorialCech.*` in `lem:cech_acyclic_affine`.

---

## TASK 3 — Fix the generality + hint debt on `def:cech_free_presheaf_complex` (around L713)

The iter-016 Lean carries `[Finite 𝒰.I₀]` (needed so `X.PresheafOfModules` has the required
coproducts; matches the downstream protected target `cech_computes_higherDirectImage`). Add to the
prose: "We assume the index set $I$ is **finite** (so the required coproducts exist in
$\mathrm{PMod}(\mathcal{O}_X)$; this matches the finiteness hypothesis of the comparison target)."
Also add a one-line note that `⨁` here is the categorical coproduct `∐` (`Limits.Sigma`), which for
finite index coincides with the finite biproduct.

The blueprint references three substantive Lean helpers with no `\lean{}` hint. Bundle them into the
`\lean{...}` list of `def:cech_free_presheaf_complex` (see TASK 5 for the full bundle list).

---

## TASK 4 — Expand the L1 bridge proof sketch in `lem:cech_acyclic_affine` (around L510)

The constant + dependent combinatorial cores (L3) and the L2 certifier are DONE and axiom-clean. The
ONLY remaining piece is the **L1 categorical→module bridge**, which the iter-016 prover identified as
a separate new-infrastructure lane, deeper than the current sketch suggests. Expand the proof's L1
paragraph into a concrete, formalizable infrastructure decomposition (this is what a mathlib-build
prover will follow). Add a paragraph covering, in order:

1. **Section identification.** For the standard cover by basic opens `D(s_σ)` (`s_σ = ∏_k s_{σ k}`),
   the sections of `pushPullObj F (D(s_σ) ↪ Spec R)` over basic opens are the away-localisation
   `M_{s_σ}` of `M = Γ(Spec R, F)`. Concretely Mathlib provides, in `AlgebraicGeometry.Modules.Tilde`,
   `instance (g : R) : IsLocalizedModule (Submonoid.powers g) (tilde.toOpen M (basicOpen g)).hom`
   and `isUnit_algebraMap_end_basicOpen`; quasicoherence of `F` connects `F` to `tilde M`. Cite
   Stacks Schemes Tag 01HV(4)–(5) (read from `references/stacks-schemes.tex`) for
   `Γ(D(g), \widetilde{M}) = M_g` and the restriction = localisation map — quote verbatim with the
   mandatory SOURCE lines (the existing L1 paragraph may already carry this quote; reuse it).
2. **Differential identification.** Under (1), the abstract `relativeCechComplexOfNerve` /
   cosimplicial differential becomes the alternating localisation coboundary, i.e. the concrete `δ`
   feeding `CombinatorialCech.Dependent.depDiff`. State the three compatibility hypotheses the bridge
   must discharge: `hu` (unit: `c ∘ δ₀ = id`), `hsh` (shift: `c ∘ δ_{k+1} = δ_k ∘ c`), `hcomm`
   (coface commutation), naming them as the interface of the dependent port.
3. **Homology ↔ exactness.** `IsZero ((CechComplex …).homology p)` reduces to
   `Function.Exact dᵖ⁻¹ dᵖ` of the underlying `R`-module cochain complex (sectionwise on the affine
   base / via the localisation identification). Feed each positive-degree node through
   `exact_of_isLocalized_span (Set.range s) hs` (localising at the spanning elements `Away (s r)`),
   and close with `CombinatorialCech.Dependent.depDiff_exact`.

Keep the statement block and `CechAcyclic.affine` signature unchanged (it is faithful per the
iter-016 lvb-checker). Do NOT route through `SimplicialObject.Augmented.ExtraDegeneracy` (documented
dead end — mention it as such).

---

## TASK 5 — Clear the 19-helper coverage debt by bundling into existing `\lean{...}` lists

Each Lean helper below has no blueprint entry (`archon dag-query unmatched` lists all 19). Append each
to the named block's multi-name `\lean{...}` list (the bundling pattern — comma-separated, the list
may span lines). Do not create new blocks for these; bundle them.

Into `lem:cech_acyclic_affine` `\lean{...}` (9 — the dependent-L3 port):
`AlgebraicGeometry.CombinatorialCech.depDiff`, `...depHomotopy`, `...depHomotopy_spec`,
`...depTransport`, `...cons_comp_zero_succAbove`, `...comp_succAbove_swap`, `...depDiff_eq_of_cocycle`,
`...depDiff_comp`, `...depDiff_exact`.

Into `def:cech_free_presheaf_complex` `\lean{...}` (7):
`AlgebraicGeometry.freeYoneda`, `AlgebraicGeometry.coverOpen`, `AlgebraicGeometry.coverInterOpen`,
`AlgebraicGeometry.coverInterOpen_comp_le`, `AlgebraicGeometry.cechFreeSimplicial`,
`AlgebraicGeometry.cechFreePresheafComplex_X`, `AlgebraicGeometry.sigma_ι_eqToHom_transport`.

Into `lem:cech_complex_hom_identification` `\lean{...}` (2):
`AlgebraicGeometry.freeYonedaHomAddEquiv`, `AlgebraicGeometry.freeYonedaHomEquiv_apply`.

Into `def:section_cech_complex` `\lean{...}` (1):
`AlgebraicGeometry.sectionCechCosimplicial`.

---

## TASK 6 — Add the new covered file

At the top of the chapter, add a covers line for the new bridge file:
`% archon:covers AlgebraicJacobian/Cohomology/CechBridge.lean`

---

## Out of scope
- Do NOT touch P5a/P5b blocks (`lem:higher_direct_image_presheaf`, `lem:cech_computes_cohomology`,
  etc.) — they are not part of this iter's lanes.
- Do NOT add `\leanok` anywhere.
- Do NOT weaken or restate the protected `cech_computes_higherDirectImage` signature.

## Report back
List every block you edited, the new `def:cover_structure_presheaf` block, and confirm all 19 helpers
are now bundled. Flag any "Strategy-modifying findings" if the math surfaced a strategy issue.
