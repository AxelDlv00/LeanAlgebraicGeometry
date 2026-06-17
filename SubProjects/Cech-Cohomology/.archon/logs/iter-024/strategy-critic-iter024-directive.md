# Strategy-critic directive — iter-024

Fresh-eyes re-verification of the project strategy. Prior verdict (iter-019) was SOUND; since then phases P4 and P3 completed and were moved to `## Completed`, and P3b is mid-execution. No route swap has occurred. Confirm the route is still sound now that P3 (standard-cover Čech vanishing, section form) is closed and P3b is the active critical path.

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for `f : X ⟶ S` separated quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover of `X`, an isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` under `[HasInjectiveResolutions X.Modules]`, with `higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`. End-state: zero inline sorry in the cone, zero project axioms, kernel-only axioms.

## Current STRATEGY.md (verbatim)

(see below — reproduced verbatim)

---
# Strategy

## Goal

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`),
the protected, frozen-signature target: for `f : X ⟶ S` separated and quasi-compact, `F`
quasi-coherent, and `𝒰` a finite affine open cover of `X`, an isomorphism in the weak
existence form `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`), where `higherDirectImage f i F =
((pushforward f).rightDerived i).obj F`. End-state: zero inline `sorry` in the cone, zero
project axioms, kernel-only axioms. Extraction from the Algebraic-Jacobian challenge; the
downstream Picard/Quot machinery is out of scope and was carved away.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| P3b Čech↔derived bridge (torsor-free) → `affine_serre_vanishing` | ACTIVE | ~3–6 | ~250–450 | `PresheafOfModules.{free,evaluation,unit,sheafificationAdjunction}`, `injective_of_adjoint`, `alternating{Coface,Face}MapComplex` — native; the direct injective-acyclicity route needs no presheaf enough-injectives. | Section + free complexes built; engine complex (`cechEngineComplex` + d²=0 + homotopy + exactness) built iter-022. Open: `cechFreeEvalEngineIso` (the ONE comm-square / differential-variance match) → `cechFreeComplex_quasiIso`; then `injective_cech_acyclic` (gated on quasi-iso), `ses_cech_h1` (independent), `cech_vanish_basis` (01EO). |
| P5a vanishing inputs (consume P3b) | ACTIVE | ~3–4 | ~200–400 | 01XJ LEAF done in **resolution form** (`homologyIsoSheafify` engine + `higherDirectImage_iso_sheafify_presheafHomology`, iter-018, axiom-clean); remaining = the deferred absolute-`Hⁿ(f⁻¹V,G)` bridge + open-immersion/affine vanishing (consume `affine_serre_vanishing`) + augmented-Čech resolution. | The re-sign fixes the LEAF, but RELOCATES (does not remove) the absolute-cohomology identification to the consumers (strategy-critic iter-019). Investigate `CategoryTheory.Sheaf.H`+forget as the cheaper realisation of `Hⁿ(open,F)` before any bespoke build. |
| P5b comparison assembly | BLOCKED | ~2–3 | ~150–300 | P4 engine + P5a resolution + termwise `f_*`-acyclicity. | Final Route-A assembly of the protected goal. |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| P1 push–pull functor laws | 002 · 2 | ~120 | `CechHigherDirectImage.lean` | `pushPullMap_comp` closing the push–pull functoriality cone | object-form align `simp [Functor.comp_obj]` before `reassoc_of%`; `rawPushPullMap`+`subst`+pentagon | `conjugateEquiv_comp` mate route INFEASIBLE (kernel `whnf` blow-up) |
| P2 `CechNerve`/`CechComplex` | 002 · 1 | ~60 | `CechHigherDirectImage.lean` | `pushPullFunctor` (G), `coverCechNerve(Aug)`, `CechNerve`, `CechComplex` axiom-clean | `Over.lift`+`.rightOp`+`CosimplicialObject.Augmented.whiskeringObj`; terminal-object augmentation | none |
| P4 acyclic-resolution lemma (Leray, Stacks 015E) | 009 · 6 (004–009) | ~965 | `AcyclicResolution.lean` | `rightDerivedIsoOfAcyclicResolution` (RⁿG ≅ Hⁿ(G K•)), `rightDerivedOneIsoCokerOfAcyclic`, horseshoe `ofShortExact`, dimension shift, cosyzygy layer — axiom-clean | decompose-then-build cadence; two-step `cokernel.mapIso` for non-syntactic homology naturality; `Nat.rec` staircase off `stairGen` | `ShortComplex.mapCyclesIso` WRONG for left-exact functor; `← G.map_comp` silently fails beside a mapped-complex term |
| P3 standard-cover Čech vanishing — **section-complex form** (tilde case) | 022 · ~14 | ~1200 | `CechAcyclic.lean` | `sectionCech_affine_vanishing` + `sectionCech_homology_exact` (IsZero homology, p≥1) for `F=~M`; L1 tilde-bridge (`phiL`/`phi`=`IsLocalizedModule.iso`, ladder `of_ladder_addEquiv_of_exact`) + L3 combinatorial core | accessor-1(`toPresheafOfModules`-Ab)↔accessor-2(`tilde.toOpen`) are DEFEQ (`rfl`) — build φ_σ directly; abstract heavy section maps (`set;clear_value`) before `IsLocalizedModule.ext` to dodge `whnf` timeout; target ABSOLUTE section complex not relative pushforward | residual general-qcoh `F≅~(ΓF)` (01I8) globalisation deferred to the 02KG consumer, NOT a P3 blocker; the old relative-form `CechAcyclic.affine` sorry is superseded/authorized |

## Routes

### Route A — acyclic-resolution comparison (CHOSEN)
The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})`) is
(i) a resolution of `F` and (ii) termwise `(pushforward f)`-acyclic. The P4 abstract lemma
"a `G`-acyclic resolution computes `G.rightDerived`" then gives `Hⁱ(f_* C•) ≅ Rⁱf_* F`
directly — ONE abstract lemma, NO spectral sequences. The standard Cartan–Leray acyclic-cover
existence proof. Its acyclicity input (ii) reduces to affine Serre vanishing
`H^q(affine, qcoh)=0`, which is NOT free: see the bridge below.

### Route B — two spectral sequences (REJECTED, fallback only)
Čech-to-derived + Leray spectral sequences for `Scheme.Modules`. Rejected: both absent from
Mathlib (multi-thousand-LOC), and Leray needs quasi-coherence of `R^q f_* F`. Strictly heavier
than Route A for the same `Nonempty (…≅…)` goal. NOTE: Route B rests on the SAME irreducible
brick `injective_cech_acyclic` as Route A — rejecting B does not escape it. Fallback only.

### The acyclicity bridge (load-bearing, CORRECTED)
Route A's term-/relative-acyclicity inputs and the general-cover intersection vanishing all
reduce to affine Serre vanishing `H^q(Spec A, qcoh)=0` (Stacks 02KG). This is NOT obtainable
from the P3 contracting homotopy alone: the homotopy proves the Čech *complex* is exact (a
resolution), but term `G`-acyclicity is itself affine vanishing on a smaller affine — a circular
regress with no inductive base. The honest route (Stacks, torsor-free) is the minimal
Čech↔derived bridge P3b: (1) injective `O_X`-modules are Čech-acyclic
(`injective_cech_acyclic`); (2) `ses_cech_h1`; (3) the dimension-shift `cech_vanish_basis` (01EO)
consuming the standard-cover Čech vanishing of P3 as its condition (3). This yields
`affine_serre_vanishing` legitimately, breaking the cycle: P3 produces standard-cover Čech
vanishing; P3b lifts it to affine sheaf vanishing without ever using affine vanishing as an input.

**Direct route for (1)**: `injective_cech_acyclic` does NOT
need presheaf enough-injectives or the δ-functor universality. Two aligned parts: (a) injective
sheaf ⟹ injective presheaf via `Injective.injective_of_adjoint` applied to the
`Mod ↪ PMod` right adjoint (`sheafificationAdjunction`); (b) the free-presheaf complex
`K(𝒰)_• = ⨁ free(yoneda U_…)` resolves `O_𝒰` (objectwise contracting homotopy) and
`Hom(K_•,F) = Č•(𝒰,F)` (section complex) via `freeAdjunction`+Yoneda — so for injective `I`,
`Hom(-,I)` exact gives positive Čech vanishing. This BYPASSES the two expensive bricks
(`presheafModules_enoughInjectives`, `cech_delta_functor_presheaves` — both off the critical path,
dropped from the blueprint). The free-presheaf complex uses Mathlib's `PresheafOfModules.free`, NOT
a bespoke `j_!`. The FULL Stacks-01EO bootstrap (torsor `lemma-cech-h1`, `lemma-kill-cohomology-class`)
remains avoidable; only the injective-acyclicity brick is irreducible.

## Open strategic questions

- **P5a re-sign (DECIDED; the LEAF node only)**: `lem:higher_direct_image_presheaf` is re-signed to the
  **resolution form** already proved (`higherDirectImage_iso_sheafify_presheafHomology`:
  `Rⁿf_*G ≅ sheafify(V↦Hⁿ((f_*I^•)(V)))` for an injective resolution `I`), backed by the reusable 01XJ
  engine `PresheafOfModules.homologyIsoSheafify`. This is the correct Lean target for the LEAF.
  **It does NOT eliminate the absolute-cohomology obligation — it relocates it** (strategy-critic
  iter-019): the downstream consumers `open_immersion_pushforward_comp` and `cech_term_pushforward_acyclic`
  feed `affine_serre_vanishing`, which is *stated* with the absolute `Hᵏ(f⁻¹V,G)`, so they still need the
  last-mile bridge `Hᵏ((f_*I^•)(V)) = Hᵏ(f⁻¹V,G)` (restricted injective resolution computes absolute
  cohomology of `f⁻¹V`). That bridge is a deferred obligation, due when those consumers are dispatched
  (gated on `affine_serre_vanishing`), NOT a thing the leaf supplies.
- **Open: how to realise absolute `Hⁿ(open,F)` (the deferred P5a bridge)** — the "module-valued Hⁿ is
  absent ⇒ fork with zero lemmas" premise may be too pessimistic: Mathlib HAS `CategoryTheory.Sheaf.H`
  for `AddCommGrp`-valued sheaves, reachable from `SheafOfModules` via a forget functor (strategy-critic
  iter-019). Investigate this cheaper path BEFORE building a bespoke module-valued cohomology, when the
  P5a consumers come up (later iters). Not on this iter's critical path (P3/P3b lanes are independent).
- **P3 re-sign (DECIDED, strategy-critic-confirmed)**: `cech_acyclic_affine` targets the **absolute
  section Čech complex** `sectionCechComplex` on `Spec R` (not the relative `CechComplex f 𝒰 F`). The
  outer `pushforward f` is a right adjoint that does not preserve homology, and affine-pushforward
  exactness is absent from Mathlib (a 3rd from-scratch brick). The Stacks 01EO/02KG route that consumes
  `cech_acyclic_affine` is always absolute; the relative complex's acyclicity (P5b) is supplied via
  `affine_serre_vanishing` + `cech_term_pushforward_acyclic` (P5a), never via `cech_acyclic_affine`.
  Analysis: `analogies/l1-bridge.md`.
- P3 exactness: `exact_of_isLocalized_span` (`Mathlib.RingTheory.LocalProperties.Exactness`) — localise
  at spanning elements `Away (s_r)`, node-by-node `Function.Exact`, close with the done
  `CombinatorialCech.Dependent.depDiff_exact`. L1 now decomposed into two sub-lanes:
  `def:qcoh_sections_localized` (`F(D(g))=M_g` via qcoh `F≅tilde(ΓF)` globalisation, Stacks 01I8) +
  `lem:section_cech_homology_exact` (`IsZero homology ↔ Function.Exact` via
  `exactAt_iff_isZero_homology`+`moduleCat_exact_iff` + the categorical↔module term/differential id).
- P3b statement shape: prove the genuine basis criterion (`cech_vanish_basis`, 01EO) via the
  bridge, NOT the circular acyclic-resolution shortcut. Its `\uses` is
  `{injective_cech_acyclic, ses_cech_h1, cech_acyclic_affine}` and explicitly NOT
  `affine_serre_vanishing` (which depends on it). Decide whether to keep the general ringed-space
  statement or narrow to the affine/standard-cover instance — either is acceptable if non-circular.
- P3b scope guard: build the MINIMAL torsor-free bridge only. Do NOT formalize `lemma-cech-h1`
  (torsor H¹) or `lemma-kill-cohomology-class`; the dimension-shift route (`cech_vanish` /
  `cech_vanish_basis`) needs only `injective_cech_acyclic` + `ses_cech_h1`.
- File-split for parallelism (standing directive): the consolidated source is split into
  `CechAcyclic.lean` (P3), `PresheafCech.lean` (P3b section side), `FreePresheafComplex.lean` (P3b
  free side), `CechBridge.lean` (P3b assembly), `HigherDirectImagePresheaf.lean` (P3-independent 01XJ
  leaf + P5a vanishing inputs), and `CechHigherDirectImage.lean` (P1/P2 push–pull + Čech machinery +
  frozen P5b assembly), each a parallel prover lane under one `% archon:covers`.
  `cech_computes_higherDirectImage` signature + path frozen.

## Mathlib gaps & new material

Gaps to fill (project-side, Mathlib lacks):
- Standard-cover Čech complex exactness `0→M→∏M_{f_i}→⋯` (P3) — Mathlib has only the H⁰/H¹
  equalizer (`IsSheafEqualizerProducts`); assemble L1+L3 around `exact_of_isLocalized_span`.
- Presheaf-level Čech machinery for `O_X`-modules (P3b): the free-presheaf complex
  `K(𝒰)_• = ⨁ free(yoneda U_…)` (via Mathlib `PresheafOfModules.free`+`yoneda`, NOT a bespoke `j_!`),
  its `Hom(K_•,F)=Č•(𝒰,F)` identification (section Čech complex, distinct from the relative
  `CechComplex`), the objectwise contracting homotopy, `injective_cech_acyclic` (via
  `Injective.injective_of_adjoint`), `ses_cech_h1`, `cech_vanish_basis`. Mathlib has the building
  blocks (`PresheafOfModules`, `free`/`freeAdjunction`, `evaluation`, `sheafificationAdjunction`,
  `injective_of_adjoint`) but NOT the assembled Čech complex/exactness. DROPPED as off-critical-path:
  presheaf enough-injectives + δ-functor universality (no `IsGrothendieckAbelian (PresheafOfModules)`,
  no functor-category transfer, no AB5 — all expensive and unnecessary for `injective_cech_acyclic`).
- `R^if_*` = sheafify of objectwise presheaf-homology for `Scheme.Modules` (P5a) — BUILT iter-018 in
  resolution form (`homologyIsoSheafify` engine + `higherDirectImage_iso_sheafify_presheafHomology`,
  axiom-clean). The standalone module-valued `Hⁿ(open,F)` (absolute form) is a fork, deliberately not built.
- Relative/open-immersion affine vanishing `R^q(jₛ)_*=0`, `R^i(affine)_*=0` (P5).

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` — hand-rolled.
- `CechNerve` / `CechComplex` / `CechAcyclic.affine` (standard-cover bundle).
- `AcyclicResolution.lean`: abstract acyclic-resolution comparison (P4, done).
- P3b bridge: free-presheaf complex `cechFreePresheafComplex` + section Čech complex +
  `cechComplex_hom_identification` + `cechFreeComplex_quasiIso` + `injective_cech_acyclic` +
  `ses_cech_h1` + `cech_vanish_basis` → `affine_serre_vanishing`.
- comparison assembly `cech_computes_higherDirectImage` via Route A.

---

## Reference index (references/summary.md)
- `stacks-coherent.{md,tex}` — Stacks ch.30 Cohomology of Schemes: 02KE (Čech computes cohomology, affine intersections), 02KG (Serre vanishing on affines), quasi-coherence of higher direct images for affine S. Backs the comparison theorem.
- `homological-acyclic-{derived,homology}.tex` — Stacks derived.tex/homology.tex: right-F-acyclic objects (0157), criterion (015C), Leray acyclicity lemma (015E). Backs the P4 acyclic-resolution chapter.
- `stacks-cohomology.{md,tex}` — Stacks Cohomology: 01XJ (R^if_* = sheafify of V↦H^i(f⁻¹V,F)), 01EO (Čech-to-cohomology comparison on a basis). Backs the P5a leaf and the P3b dimension-shift.
- `stacks-schemes.{md,tex}` — Stacks Schemes: 01HV (Γ(Spec R,~M)=M, Γ(D(f),~M)=M_f). Backs the tilde construction.

## Blueprint chapters (titles, one-line topic each)
- `Cohomology_AcyclicResolution.tex` — "Acyclic resolutions compute right-derived functors" (Leray 015E, P4 — done).
- `Cohomology_CechHigherDirectImage.tex` — Čech computation of higher direct images; consolidated chapter covering the P3/P3b files (CechAcyclic, PresheafCech, FreePresheafComplex, CechBridge) + the comparison assembly.
- `Cohomology_HigherDirectImage.tex` — "Higher direct images R^i f_* of quasi-coherent sheaves (i≥1)" (P5a 01XJ leaf, resolution form).

## What I need
Re-verify the global skeleton is sound and the P3b bridge (injective-acyclicity + ses_cech_h1 + cech_vanish_basis → affine_serre_vanishing, breaking the affine-vanishing circularity) is the correct minimal route, now that P3 is closed. Flag any still-live challenge from iter-019 that the P3 completion did not address, or any new structural concern. CHALLENGE/REJECT must be explicit; SOUND if the route holds.
