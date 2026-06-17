# Strategy-critic directive — iter-027

Read the current strategy as a fresh mathematician with no investment in the project's momentum.
Challenge the route choices on the mathematics, not on sunk cost.

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for
`f : X ⟶ S` separated and quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover of
`X`, an isomorphism (weak/`Nonempty` form) between the homology of the Čech complex
`(CechComplex f 𝒰 F).homology i` and the higher direct image `higherDirectImage f i F =
((pushforward f).rightDerived i).obj F`, under `[HasInjectiveResolutions X.Modules]`. End-state:
zero inline `sorry` in the cone, zero project axioms, kernel-only axioms.

## A specific still-live point to re-verify
Last iter you (the strategy-critic) CHALLENGED the absolute-cohomology realization, proposing a
switch from the **Ext-of-the-corepresenting-object (Form B)** route to a hand-built
`rightDerived`-global δ-long-exact-sequence. The planner rebutted, retaining Form B, on the
ground that Form B needs only the corepresenting *object* `jShriekOU = sheafify(free(yoneda U))`
(cheap, built from already-shipped pieces), NOT the full `j_!` functor (which is absent from
Mathlib, 200–500 LOC) — so the LES and injective-vanishing both come off-the-shelf from
`Abelian.Ext` with the short exact sequence never leaving `X.Modules`. Since then, Form B has been
**realized in Lean and landed axiom-clean** (10 declarations, 0 sorries): `jShriekOU`, the
corepresentability iso, `absoluteCohomology := Ext^p(jShriekOU U, -)`, `H⁰≅Γ`, the
injective-vanishing wrapper (a one-liner via `Ext.eq_zero_of_injective`, injective as the 2nd
arg), and the three covariant-LES wrappers. Re-assess whether this empirical landing settles your
challenge, or whether you still see a structural problem with Form B as the absolute-cohomology
realization feeding 01EO/02KG.

## Current STRATEGY.md (verbatim)

```markdown
# Strategy

## Goal

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`),
the protected, frozen-signature target: for `f : X ⟶ S` separated and quasi-compact, `F`
quasi-coherent, `𝒰` a finite affine open cover of `X`, an isomorphism in the weak existence
form `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`), with `higherDirectImage f i F =
((pushforward f).rightDerived i).obj F`. End-state: zero inline `sorry` in the cone, zero
project axioms, kernel-only axioms.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| P3b absolute cohomology + 01EO/02KG → `affine_serre_vanishing` | ACTIVE | ~3–5 | ~250–500 | `Abelian.Ext` (LES + injective vanishing off-the-shelf); `PresheafOfModules.{free,sheafificationAdjunction}` for the corepresenting object. | Bridge bricks done. Next: scaffold absolute cohomology (Form B, below) then 01EO (large) → 02KG. |
| P5a vanishing inputs (consume P3b) | ACTIVE | ~3–4 | ~200–400 | 01XJ leaf done (resolution form); remaining = absolute-`Hⁿ(f⁻¹V,G)` bridge (Ext-via-injective-resolution) + open-immersion/affine vanishing + augmented-Čech resolution. | Last-mile bridge `Hᵏ((f_*I^•)(V))=Ext^k(jShriek(f⁻¹V),G)` is Ext-computed-by-injective-resolution. |
| P5b comparison assembly | BLOCKED | ~2–3 | ~150–300 | P4 engine + P5a resolution + termwise `f_*`-acyclicity. | Final Route-A assembly of the protected goal. |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| P1 push–pull functor laws | 002 · 2 | ~120 | `CechHigherDirectImage.lean` | `pushPullMap_comp` closing push–pull functoriality | object-form align `simp [Functor.comp_obj]` before `reassoc_of%`; `rawPushPullMap`+`subst`+pentagon | `conjugateEquiv_comp` mate route INFEASIBLE (kernel `whnf` blow-up) |
| P2 `CechNerve`/`CechComplex` | 002 · 1 | ~60 | `CechHigherDirectImage.lean` | `pushPullFunctor`, `coverCechNerve(Aug)`, `CechNerve`, `CechComplex` axiom-clean | `Over.lift`+`.rightOp`+`CosimplicialObject.Augmented.whiskeringObj`; terminal augmentation | none |
| P4 acyclic-resolution lemma (Leray, 015E) | 009 · 6 | ~965 | `AcyclicResolution.lean` | `rightDerivedIsoOfAcyclicResolution`, `rightDerivedOneIsoCokerOfAcyclic`, horseshoe `ofShortExact`, dimension shift — axiom-clean | decompose-then-build; two-step `cokernel.mapIso`; `Nat.rec` staircase off `stairGen` | `ShortComplex.mapCyclesIso` WRONG for left-exact functor; `← G.map_comp` silently fails by a mapped-complex term |
| P3 standard-cover Čech vanishing (section form, tilde) | 022 · ~14 | ~1200 | `CechAcyclic.lean` | `sectionCech_affine_vanishing` + `sectionCech_homology_exact` (IsZero homology p≥1) for `F=~M`; L1 tilde-bridge + L3 combinatorial core | accessors DEFEQ (`rfl`); abstract section maps (`set;clear_value`) before `IsLocalizedModule.ext`; target ABSOLUTE section complex | residual qcoh `F≅~ΓF` (01I8) deferred to 02KG consumer; old relative `affine` sorry superseded |
| P3b Čech↔derived bridge bricks | 025 · ~9 | ~1500 | `PresheafCech`,`FreePresheafComplex`,`CechBridge` | `cechFreeComplex_quasiIso` (free resolution of `O_𝒰`), `ses_cech_h1`, `injective_cech_acyclic` (pos-degree Čech vanishing for injectives) — axiom-clean | op-transport via `opFunctor`+`preadditiveYoneda`; `erw`+`.trans` for defeq-carrier mismatch; Route-B arrow-iso transfer | `maxHeartbeats 2000000` needed; LSP-staleness (trust only `lake env lean`) |

## Routes

### Route A — acyclic-resolution comparison (CHOSEN)
The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})`) is
(i) a resolution of `F` and (ii) termwise `(pushforward f)`-acyclic. The P4 abstract lemma
gives `Hⁱ(f_* C•) ≅ Rⁱf_* F` directly — ONE abstract lemma, NO spectral sequences. Acyclicity
input (ii) reduces to affine Serre vanishing `H^q(affine, qcoh)=0`, supplied by the P3b bridge.

### Route B — two spectral sequences (REJECTED, fallback only)
Both absent from Mathlib (multi-thousand-LOC), and Leray needs quasi-coherence of `R^q f_* F`.
Rests on the same `injective_cech_acyclic` brick as A — rejecting B does not escape it.

### The acyclicity bridge (torsor-free, load-bearing)
Route A's acyclicity reduces to affine Serre vanishing `H^q(Spec A, qcoh)=0` (02KG). The honest
non-circular route is the minimal Čech↔derived bridge: (1) `injective_cech_acyclic`, (2)
`ses_cech_h1`, (3) the dimension-shift `cech_eq_cohomology_of_basis` (01EO) consuming the
standard-cover Čech vanishing of P3 as its condition (3). All three bricks of (1)+(2) are done;
01EO is the next target. This breaks the circular regress: P3 produces standard-cover Čech
vanishing; the bridge lifts it to affine sheaf vanishing without ever using affine vanishing.

### Absolute cohomology realization — Ext of the corepresenting object (Form B)
`H^p(U, F) := Ext^p_{X.Modules}(jShriekOU U, F)` where `jShriekOU U := sheafify(free(yoneda U))`
is the corepresenting object of `F ↦ Γ(U,F) = F(U)` (`= j_!O_U` up to iso), built from the
already-shipped `freeYonedaHomEquiv` + `sheafificationAdjunction` (~50–80 LOC). The three facts
01EO consumes are then off-the-shelf with the SES staying in `X.Modules`: injective vanishing
`Ext.eq_zero_of_injective` (injective `I` as the 2nd arg — no restriction taken), covariant LES
`Ext.covariant_sequence_exact₁/₂/₃` at fixed 1st arg `jShriekOU U`, and `H⁰ ≅ Γ(U,F)` via the
corepresentability chain. The discarded alternatives: Form A `Ext(O_U, F|_U)` needs
restriction-preserves-injectives (≈ a 200–500 LOC `j_!` functor); `Functor.rightDerived` has
free injective vanishing but no packaged LES; `Sheaf.H` is absent. Reversal signal: Ext
universe/smallness pain over `SheafOfModules` → fall back to Route γ (Čech colimit), never `Sheaf.H`.

## Open strategic questions

- P5a last-mile bridge: `Hᵏ((f_*I^•)(V)) = Ext^k(jShriek(f⁻¹V), G)` (Ext computed by an injective
  resolution of the 2nd arg); due when the P5a consumers are dispatched (gated on `affine_serre_vanishing`).
- P3b 01EO statement shape: general ringed-space basis criterion vs. affine/standard-cover instance —
  either acceptable if non-circular; `\uses {injective_cech_acyclic, ses_cech_h1, cech_acyclic_affine}`,
  NOT `affine_serre_vanishing`.
- General-qcoh `F≅~(ΓF)` (01I8) globalisation: residual reduction of arbitrary qcoh on an affine to the
  tilde case; consumed by the 02KG/02KE general-F assembly + `cechAugmented_exact`. Build when reached.

## Mathlib gaps & new material

Gaps to fill (project-side, Mathlib lacks):
- Standard-cover Čech complex exactness `0→M→∏M_{f_i}→⋯` (P3) — done via L1+L3 around `exact_of_isLocalized_span`.
- Presheaf-level Čech machinery for `O_X`-modules (P3b free/section complexes, `injective_cech_acyclic`,
  `ses_cech_h1`) — done. Dropped as off-critical-path: presheaf enough-injectives + δ-functor universality.
- Absolute module-valued `Hⁿ(U,F)` = `Ext^p(jShriekOU U, F)` via `Abelian.Ext` (Form B); corepresenting
  object `jShriekOU = sheafify(free(yoneda U))`. NOT a bespoke `j_!` functor (that is absent, 200–500 LOC).
- Relative/open-immersion affine vanishing `R^q(jₛ)_*=0`, `R^i(affine)_*=0` (P5).

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` — hand-rolled.
- `CechNerve`/`CechComplex`; `AcyclicResolution.lean` (P4); P3b free-presheaf + section Čech complexes,
  `cechFreeComplex_quasiIso`, `injective_cech_acyclic`, `ses_cech_h1`.
- `AbsoluteCohomology.lean`: `jShriekOU`, corepresentability iso, `H^p := Ext^p(jShriekOU U, -)`, H⁰=Γ,
  injective-vanishing + LES wrappers → 01EO `cech_eq_cohomology_of_basis` → 02KG `affine_serre_vanishing`.
- comparison assembly `cech_computes_higherDirectImage` via Route A.
```

## References index (one line each)
- `stacks-coherent.{md,tex}` — Stacks "Cohomology of Schemes": 02KE (Čech computes cohomology when
  intersections affine), 02KG (Serre vanishing on affines), standard-cover Čech vanishing.
- `stacks-cohomology.{md,tex}` — Stacks "Cohomology": 01XJ (Rⁱf_* is sheafification of
  V↦Hⁱ(f⁻¹V,F)), 01EO (Čech-to-cohomology comparison on a basis, the next target).
- `homological-acyclic-{derived,homology}.tex` — Stacks derived.tex/homology.tex: right-F-acyclic
  objects (0157), criterion (015C), Leray acyclicity lemma (015E), enough acyclics (05TA).
- `stacks-schemes.{md,tex}` — Stacks "Schemes": 01HV (`Γ(Spec R, ~M)=M`, `Γ(D(f),~M)=M_f`).

## Blueprint chapters (title + one-line topic)
- `Cohomology_AcyclicResolution.tex` — "Acyclic resolutions compute right-derived functors" (P4
  Leray/Cartan–Leray engine, 015E; done).
- `Cohomology_CechHigherDirectImage.tex` — the consolidated Čech chapter (covers 7 Lean files):
  Čech nerve/complex, affine acyclicity (P3), presheaf Čech machinery + bridge (P3b), absolute
  cohomology as Ext (Form B), 01EO comparison, 02KG Serre vanishing, and the `R^i f_*` comparison.
- `Cohomology_HigherDirectImage.tex` — "Higher direct images Rⁱf_* of quasi-coherent sheaves (i≥1)".

## What I need from you
1. A verdict (SOUND / CHALLENGE / REJECT) on the overall strategy, with the still-live Form-B vs
   `rightDerived`-global point explicitly resolved given the empirical Lean landing.
2. Any structural concern about the 01EO → 02KG → Route-A acyclicity-bridge chain (the
   load-bearing path to the protected goal) — in particular whether the dimension-shift 01EO is
   genuinely non-circular as claimed (it must not consume `affine_serre_vanishing`).
3. Whether the general-vs-affine-specialized 01EO statement-shape question (open question #2) has a
   strategically preferable answer.
