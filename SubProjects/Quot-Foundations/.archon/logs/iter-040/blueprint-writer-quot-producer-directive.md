# Blueprint-writer directive — Picard_QuotScheme.tex (gap1 section-transport producer + coverage + sketch fix)

## Chapter to edit
`blueprint/src/chapters/Picard_QuotScheme.tex` (ONLY this file). You may spawn a
reference-retriever if you need a source you lack (write-domain includes `references/**`).

## Strategy context (the slice that matters)
The QUOT gap1 keystone `lem:section_localization_descent`
(`\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent}`, NOT yet in Lean) is the
descent that exhibits, for a quasi-coherent `M` on `Spec R` and any `f ∈ R`, the restriction
`Γ(M,⊤) → Γ(M,D(f))` as `IsLocalizedModule (powers f)`. Every CONSUMER of this descent is now built
axiom-clean in Lean; the sole remaining work is the **geometric section-transport producer** that
manufactures the per-cover-element localization hypothesis `Hfr`. This iter's job is to (1) fix a
known dead-end in the existing proof sketch, (2) blueprint three already-built feeder lemmas that are
currently DAG-unmatched, and (3) author a decomposed `\uses`-linked sub-lemma chain for the
section-transport producer so a `mathlib-build` prover can attack it in small pieces.

## TASK 1 — Fix the `lem:section_localization_descent` proof sketch (MUST-FIX, flagged by the
   lean-vs-blueprint-checker iter-039)
The current proof block (around lines 3949–3985) and the lemma block (around line 3886) route the
assembly through `lem:section_localization_descent_of_cover` — the **general-U** cover form whose `Hfr`
hypothesis demands a localization on EVERY open `U ≤ D(r)`. The prover has established this is **not
instantiable** for a quasi-coherent `M`: a general open of the affine slice `Spec R_r` need not be
quasi-compact, so the section localization is unavailable there. The sheaf-gluing engines only ever
consult `Hfr` at basic opens `D(s)` and overlaps `D(r)⊓D(r') = D(r·r')` (all quasi-compact).

Fix:
- Re-route the sketch through the **basic-open form** `lem:section_localization_descent_of_basicOpen_cover`
  (you add its block in TASK 2.1 below). State that `Hfr` need only be produced for basic opens
  `D(s) ≤ D(r)` (`r` in the cover), not arbitrary `U`.
- Update the `\uses{}` in BOTH the lemma block (line ~3889) and the proof block (line ~3950):
  replace `lem:section_localization_descent_of_cover` with
  `lem:section_localization_descent_of_basicOpen_cover`, and ADD
  `lem:isLocalizedModule_powers_transport` and the new producer lemma
  `lem:section_localization_hfr_basicOpen` (TASK 3) to the proof block's `\uses`.
- Keep the Stacks `lemma-invert-f-sections` SOURCE/SOURCE QUOTE comments intact (they are correct).
- Update the in-block `% NOTE` lines: the keystone is now blocked ONLY on the geometric producer
  `lem:section_localization_hfr_basicOpen`; the consuming chain (cover form, bridges I/II, iso-invariance)
  is all axiom-clean.

## TASK 2 — Blueprint the three DAG-unmatched feeder lemmas (already proved axiom-clean in Lean)
Add a `\begin{lemma}…\end{lemma}` block for each, with `\label`, `\lean{}`, accurate `\uses{}`, and a
short (1–3 sentence) informal proof. These are project-internal (no external SOURCE needed beyond the
already-cited Stacks tags they descend from).

2.1 `lem:section_localization_descent_of_basicOpen_cover`
  - `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_basicOpen_cover}`
  - Statement: same conclusion as `lem:section_localization_descent_of_cover`
    (`Γ(M,⊤) → Γ(M,D(f))` is `IsLocalizedModule (powers f)`), but the `Hfr` hypothesis is required only
    for BASIC opens: for every `s : R` with `D(s) ≤` some cover member `D(r)`,
    `Γ(M,D(s)) → Γ(M, D(f)⊓D(s))` is `IsLocalizedModule (powers f)`.
  - `\uses{lem:section_localization_descent_of_cover}` (it shares the same private sheaf-gluing engines)
    plus the same gluing deps the `_of_cover` block already uses
    (`lem:map_units_restrict_basicOpen`, plus the Mathlib gluing anchors the `_of_cover` block cites).
  - Proof: thin wrapper — the private engines `descent_surj`/`descent_smul_eq_zero` only ever call `Hfr`
    at basic opens `D(r)` and overlaps `D(r·r') = D(r)⊓D(r')` (via `PrimeSpectrum.basicOpen_mul`), so the
    basic-open hypothesis suffices to rebuild all three `IsLocalizedModule` fields. NOTE in the block that
    the general-U `_of_cover` form is axiom-clean but its `Hfr` cannot be discharged for arbitrary
    quasi-coherent `M` (only for globally-presented ones); THIS basic-open form is the one gap1 uses.

2.2 `lem:isLocalizedModule_powers_transport`
  - `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_powers_transport}`
  - Statement: the combined bridge (I)+(II). Given a ring iso `σ : S ≃+* A` with `[Algebra R A]`,
    elements `f : R`, `f' : S` with `σ f' = algebraMap R A f`, a localization `g : M₁ →ₗ[S] M₂` at
    `powers f'`, a σ-semilinear `AddEquiv` pair `e₁ : M₁ ≃+ N₁`, `e₂ : M₂ ≃+ N₂` (with
    `[Module A Nᵢ] [Module R Nᵢ] [IsScalarTower R A Nᵢ]`), and an `A`-linear `h : N₁ →ₗ[A] N₂` intertwining
    (`h (e₁ x) = e₂ (g x)`), the `restrictScalars R` of `h` is `IsLocalizedModule (powers f)` over `R`.
  - `\uses{lem:isLocalizedModule_ringEquiv_semilinear, lem:isLocalizedModule_restrictScalars_powers_algebraMap}`
    (Mathlib `Submonoid.map_powers` as the rewrite linking `(powers f').map σ = powers (algebraMap R A f)`).
  - Proof: chain bridge (I) (semilinear ring-iso transport) to land `IsLocalizedModule ((powers f').map σ) h`,
    rewrite the submonoid via `Submonoid.map_powers` + `σ f' = algebraMap R A f` to
    `powers (algebraMap R A f)`, then bridge (II) descends to `powers f` over `R` after `restrictScalars R`.
  - Role note: this is the algebra/category-free CORE the Hfr producer feeds — the final combiner.

2.3 `lem:isIso_fromTildeΓ_of_iso`
  - `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_iso}`
  - Statement: if `M ≅ M'` as modules on `Spec R` and `IsIso M.fromTildeΓ`, then `IsIso M'.fromTildeΓ`.
  - `\uses{lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict}` (Mathlib `isIso_fromTildeΓ_iff`,
    `Functor.essImage.ofIso`).
  - Proof: one line — `isIso_fromTildeΓ_iff` turns both into essential-image membership of `tilde`;
    `Functor.essImage.ofIso` transports across the iso.

## TASK 3 — Author the section-transport producer as a decomposed sub-lemma chain
This is the genuine remaining build (~200–400 LOC of geometry, `mathlib-build`). Write a NEW subsection
"Section-transport producer for the basic-open Hfr" with a TOP lemma and a `\uses`-linked chain of the
sub-pieces the prover handed off. Source the math from the prover's decomposition below (gaps a–d) and
the already-cited Stacks `lemma-invert-f-sections` / the existing `lem:pullback_gamma_top_iso`,
`lem:gamma_pullback_image_iso`, `def:gamma_image_ring_equiv` blocks (do NOT re-derive those — `\uses` them).

TOP lemma `lem:section_localization_hfr_basicOpen`:
  - `\lean{AlgebraicGeometry.Scheme.Modules.section_localization_hfr_basicOpen}` (does NOT exist yet —
    this is the producer the next prover builds; pin the intended name).
  - Statement: for a quasi-coherent `M` on `Spec R`, a cover member `D(r)` with `D(r) ≤ q.X i`, and
    `s : R` with `D(s) ≤ D(r)`, the restriction `Γ(M,D(s)) → Γ(M, D(f)⊓D(s))` is
    `IsLocalizedModule (powers f)` over `R` — i.e. the basic-open `Hfr` datum.
  - `\uses{}` the sub-lemmas below + `lem:isLocalizedModule_powers_transport`,
    `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`, `lem:isIso_fromTildeΓ_of_iso`,
    `lem:pullback_gamma_top_iso`, `lem:gamma_pullback_image_iso`,
    `lem:gamma_pullback_image_iso_hom_semilinear`, `def:gamma_image_ring_equiv`,
    `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`.

Sub-lemma chain (one block each; informal proof from the decomposition; mark each `\lean{}` with the
intended decl name — the prover creates them):

  (a) `lem:pullback_composite_immersion_isIso_fromTildeΓ` — for the composite open immersion
      `j := isoSpec.inv ≫ ι_W ≫ ι_{q.X i} : Spec R_s ⟶ Spec R` (with `W = ι_{q.X i}⁻¹ᵁ D(s)`),
      `(pullback j).obj M ≅` the iterated pullback `(pullback isoSpec.inv).obj ((pullback ι_W).obj
      ((pullback ι).obj M))` via the `Scheme.Modules.pullback` `pullbackComp` pseudofunctor coherences;
      then `isIso_fromTildeΓ_of_iso` (2.3) + P1
      (`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`) give `IsIso ((pullback j).obj M).fromTildeΓ`.
      Informal proof: pseudofunctoriality of `Scheme.Modules.pullback` for the 3-fold composite, then
      transport P1's `IsIso fromTildeΓ` across the resulting iso.

  (b) `lem:composite_immersion_range_basicOpen` — image/range computations for `j`:
      `j.opensRange = D(s)`; for `f' := σ⁻¹ (algebraMap R R_s f)` (`σ = gammaImageRingEquiv j ⊤`),
      `j ''ᵁ D(f') = D(f) ⊓ D(s)`, and `σ f' = algebraMap R R_s f` (the `hf` of
      `isLocalizedModule_powers_transport`). Informal proof: open-immersion range of a composite of basic-
      open / affine-identification immersions; image of a basic open under `j` computed on the
      structure-sheaf side via `σ`.

  (c) `lem:gamma_image_iso_semilinear_top` — upgrade the `D(f')`-level semilinearity
      (`gamma_pullback_image_iso_hom_semilinear`, semilinear over `gammaImageRingEquiv j (D f')`) to the
      ⊤-level σ = `gammaImageRingEquiv j ⊤` needed for the `R_s`-actions, via naturality of
      `gammaImageRingEquiv` / structure-sheaf restriction. Informal proof: the restriction
      `Γ(⊤) → Γ(D f')` intertwines the two `gammaImageRingEquiv`s; transport the semilinearity along it.

  (d) `lem:flocus_section_scalar_tower` — the `A`-module + `IsScalarTower R A` instances on the f-locus
      sections `Γ(M, j''ᵁ D(f'))`, where `A = Γ(M, D(s))` natively but the action is by restriction from
      `Γ(R, j''ᵁ D(f'))`. Informal proof: `RestrictScalars` along the structure-sheaf restriction map;
      scalar-tower from the ring-map factorization.

  Then `lem:section_localization_hfr_basicOpen` assembles: from (a) + the in-file engine
  `isLocalizedModule_restrict_of_isIso_fromTildeΓ` get a localization at `powers f'` over `R_s`; package
  the section transports (`pullback_gamma_top_iso` + `gamma_pullback_image_iso`) as the `e₁,e₂` AddEquivs,
  use (b)/(c)/(d) to supply `σ`, `hf`, semilinearity and scalar-tower, and feed
  `isLocalizedModule_powers_transport` (2.2) to read back `powers f` over `R`.

Add a NOTE that an ALTERNATIVE to the composite-immersion route (a)+(b) is to compose THREE
`gamma_pullback_image_iso`s (one per pullback stage) with nested-image bookkeeping; either way (b)+(c)+(d)
remain. The prover picks.

## TASK 4 — Blueprint the older DAG-unmatched Scheme.Modules helpers (coverage debt)
These five are already-proved private-ish gap1-D engines that appear in `archon dag-query unmatched`.
Give each a TERSE block (statement + `\label` + `\lean{}` + minimal `\uses` + one-line proof). If you
judge any to be a genuine pure-implementation detail better left out of the DAG, add a one-line
`% NOTE: implementation detail of lem:section_localization_descent_of_cover` instead — but a terse block
is preferred so the dependency edges exist.
  - `AlgebraicGeometry.Scheme.Modules.descent_surj`
  - `AlgebraicGeometry.Scheme.Modules.descent_smul_eq_zero`
  - `AlgebraicGeometry.Scheme.Modules.descent_overlap_agree`
  - `AlgebraicGeometry.Scheme.Modules.res_comp`
  - `AlgebraicGeometry.Scheme.Modules.iSup_basicOpen_subtype_eq_top`
  All are sub-steps of `lem:section_localization_descent_of_cover` (the sheaf-gluing of the three
  `IsLocalizedModule` fields). Group them under that lemma's neighbourhood with `\uses` pointing at it
  where appropriate.

## Out of scope
- Do NOT touch the four protected `QuotFunctor`/`Grassmannian` stub blocks.
- Do NOT add `\leanok` anywhere (the deterministic sync owns it).
- Do NOT edit any other chapter.
- Do NOT alter `def:hilbert_polynomial`/SNAP blocks.

## Deliverable
The updated chapter with: TASK 1 sketch re-route done; TASK 2 three feeder blocks added; TASK 3 producer
subsection with the top lemma + four sub-lemmas (a)–(d), all `\uses`-linked; TASK 4 five coverage blocks.
Report which labels you created and any place you judged a helper better left private.
