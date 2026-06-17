# Strategy Critic Report

## Slug
iter057

## Iteration
057

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — Leray (015E/P4) on an f_*-acyclic resolution gives `Hⁱ(f_* C•) ≅ Rⁱf_* F`; `f_* C•` is literally `CechComplex f 𝒰 F` (`f_*(j_σ)_* = (f∘j_σ)_*`, finite product), so the protected `Nonempty (homology i ≅ higherDirectImage i F)` follows. No gap between route end-state and goal.
- **Mathematical soundness**: PASS — the two inputs (i) `cechAugmented_exact` (resolution) and (ii) termwise f_*-acyclicity ARE exactly the two hypotheses of 015E. R^i f_* commutes with the finite product (additive), so termwise acyclicity = `R^i f_*((j_σ)_*F|_{U_σ})=0`, which is the open-immersion-acyclicity row. These are the genuinely irreducible inputs of this route, not a deferral.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the coproduct→product module-sheaf iso (Sub-brick A leaf), Need#1, and Need#2 are all built IN-PROJECT with iter estimates and named precedents (`coprodPresheafObjIso`, `isProductOfDisjoint`, `Scheme.isoSpec`, `Ext.mapExactFunctor`). Nothing is parked on "upstream Mathlib".
- **Phantom prerequisites**: none — see Prerequisite verification (all spot-checked names exist).
- **Effort honesty**: under-counted (P5a-resolution) — see Must-fix. Other rows reasonable.
- **Parallelism under-exploited**: no — P5a-resolution (exactness) and P5a-consumer (termwise acyclicity) are independent and correctly carried as two separate ACTIVE rows feeding P5b; they should run as concurrent lanes.
- **Verdict**: SOUND

**On Focus Q1 (irreducibility).** (i) and (ii) are the definitional inputs of Leray's lemma — within Route A there is no cheaper path; you cannot have a Leray comparison without a resolution and termwise acyclicity. The only structurally different alternative is the 01XJ-sheafification + 02KE route (below), which needs MORE (01XJ is unbuilt), so Route A's choice is correct, not sunk-cost.

**On Focus Q2 (circularity).** No hidden circularity. The chain bottoms at P3 standard-cover Čech vanishing — pure commutative algebra (`0→M→∏M_{fᵢ}→⋯`), no cohomology, no f_*. 01EO lifts it to absolute affine vanishing (02KG) via the Form-B Ext machinery, which uses injective resolutions in `X.Modules` but neither affine vanishing nor f_*-acyclicity nor the main theorem. (ii)→02KG consumes the standalone 02KG result; 02KG is independently `Completed`. The "torsor-free acyclicity bridge" route documents this non-regress correctly.

**On Focus Q3 (Need#1 soundness) — adjudicated SOUND.** The whole-scheme transport `V≅SpecΓV` induces an *equivalence* of module categories, hence an exact functor (`PreservesFiniteLimits` + `PreservesFiniteColimits` + `Additive`) — exactly the hypotheses `Ext.mapExactFunctor` requires (verified present). This is categorically distinct from the REJECTED open-subscheme transport: `j⁻¹V≅SpecΓ(j⁻¹V)` would force the *restriction* `j^*` (one leg of `j_! ⊣ j^* ⊣ j_*`, an exact-but-not-equivalence functor) to preserve injectives — the wall. The distinction is real and the rejection is correct. The project additionally routes the 01EO *seed* (condition 3) through the concrete section Čech complex (ambient sections `Γ(U_σ,H)`, re-instantiating P3's `{R}[CommRing R]`-polymorphic core over `A=Γ(V)`), so it never converts an ambient `Ext_{(Spec R).Modules}(jShriekOU V, H)` into a restricted `Ext_{V.Modules}(O_V, H|_V)`. That conversion would be the wall; the project avoids it.
  - **Recommendation (non-blocking):** STRATEGY.md should state in one clause that the Ext transported by Need#1 is the STANDALONE `Ext_{V.Modules}` (cohomology of `V` as its own scheme), NOT the ambient `Ext_{X.Modules}(jShriekOU V, -)`, and that the ambient↔concrete bridge is the 01EO Čech comparison rather than an ambient→restricted Ext map. Without that note a future prover could re-derive the wall by implementing the `Ext.mapExactFunctor` step against `jShriekOU` directly.

### Route: SS — two spectral sequences (REJECTED)

- **Verdict**: SOUND (rejection is correct) — both spectral sequences are absent from Mathlib and rest on the same `injective_cech_acyclic` brick as A; rejecting it in favour of the single Leray lemma is the right call. (Format note: a one-line "rejected, reason" pointer is acceptable, but rejected-alternative detail ideally lives in an iter sidecar — see Format compliance.)

### Route: `cechAugmented_exact` — sections/sheafification (P5a resolution input)

- **Goal-alignment**: PASS — produces input (i) of Route A for ANY O_X-module / ANY cover; qcoh/affineness correctly deferred to the downstream f_*-acyclicity, not assumed here.
- **Mathematical soundness**: PASS — reflect `IsZero(Hᵖ)` through faithful additive `toSheaf`; homology sheaf = sheafification of presheaf homology; presheaf homology locally zero on `{V⊆Uᵢ}` via the prepend-`i_fix` contracting homotopy (restricted cover has a member `=V`). The "DEAD ends" list (no `SheafOfModules.stalk`; tilde/standard-cover is the wrong cover; naive per-affine section exactness is circular `Ȟᵖ(V,·)≠0`) shows the soundness traps were correctly identified.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — Sub-brick A's lone new primitive (indexed coproduct→product module-sheaf iso) is a bounded in-file leaf with binary/structure-sheaf precedents named.
- **Effort honesty**: under-counted — see Must-fix.
- **Verdict**: SOUND (with the effort CHALLENGE below).

### Route: Absolute cohomology — Ext of the corepresenting object (Form B)

- **Goal-alignment**: PASS — `H^p(U,F):=Ext^p_{X.Modules}(jShriekOU U, F)` keeps the SES inside `X.Modules`, so 01EO's three inputs (injective vanishing in the 2nd arg, covariant LES, `H⁰≅Γ`) are off-the-shelf. Form B is precisely what dodges the restriction-preserves-injectives functor (Form A's `j_!`, ~200–500 LOC).
- **Mathematical soundness**: PASS — corepresentability `F↦Γ(U,F)` via `freeYonedaHomEquiv`+`sheafificationAdjunction`; `Ext.covariant_sequence_exact₂` and friends verified present.
- **Verdict**: SOUND.

## Format compliance

- **Size**: 128 lines / ~12 KB — within the 250-line budget; near the KB ceiling but acceptable.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes (minor) — `REJECTED (analogist iter-056)` (Phases Risks cell and Need#1 route prose) names a specific iteration in prose. The `## Completed` `Iters` cells (`048 · ~14 (040→048)`) are the allowed ledger. Recommend trimming the inline `iter-056` attributions to `(analogist)` or moving them to the iter sidecar.
- **Accumulation detected**: yes (minor) — Route SS (REJECTED) and several `## Completed` cells (e.g. the 01I8 and P3b rows) pack 3–4 clauses into single cells, drifting toward prose-in-cells. No completed phase is left in the active table; no live route is mis-placed.
- **Table discipline**: PASS — both tables have the canonical columns; `Status` uses short inline tags; `LOC` uses remaining-LOC ranges.
- **Format verdict**: DRIFTED — minor only; not a must-fix this iter. Recommend de-narrativising the `iter-056` references and thinning the densest `## Completed` cells opportunistically.

## Effort-honesty finding

P5a-resolution is self-described as **"Stub 2 is 01I8-comparable sheaf infra (that route overran ~7×)"** yet estimated `~3–5` iters / `~200–350` LOC. 01I8 realized `~14` iters / `~900` LOC (`## Completed`). The estimate may be defensible — only Stub 2 (one coproduct→product iso), not the full keystone, is the comparable piece, and Stubs 1/3/4/5/6 are LOW–MEDIUM — but the strategy does not decompose the 6 stubs into per-stub iter/LOC, so the `3–5` figure is presently unjustified against the planner's own "overran ~7×" precedent. This is the dishonest-estimate signal the descriptor flags (remaining phase of partly-comparable scope estimated at a fraction of a completed peer).

## Must-fix-this-iter

- Route `cechAugmented_exact` (P5a-resolution): effort CHALLENGE — either (a) decompose Sub-brick A's 6 stubs in the Phases table / blueprint with per-stub iter+LOC so the `~3–5` / `~200–350` is auditable, or (b) widen the estimate to acknowledge the self-flagged 01I8-comparable risk on Stub 2 (e.g. `~3–8` iters). Pick one and record it; do not leave "01I8-comparable, overran 7×" and "3–5 iters" side by side unreconciled.

## Alternative routes (suggested)

### Alternative: 01XJ sheafification + 02KE direct comparison

- **What it looks like**: Use 01XJ (`R^if_*F = sheafify(V↦H^i(f^{-1}V,F))`) plus 02KE (Čech computes `H^i` when intersections are affine) on the cover `{Uᵢ∩f^{-1}V}` of `f^{-1}V`, then identify the sheafified Čech complex with `CechComplex f 𝒰 F`.
- **Why it might be cheaper or sounder**: it is the textbook route for the relative statement and avoids needing the augmented complex to be a *global* resolution.
- **What the current strategy may have rejected**: 01XJ (`lemma-describe-higher-direct-images`, a substantial unbuilt result) is not in Mathlib and not in the project, whereas Leray/P4 is already `Completed`. So this alternative needs MORE, not less. The strategy's implicit rejection is correct.
- **Severity of the omission**: minor (documenting why 01XJ is not used would harden the route record, but the choice is right).

## Prerequisite verification

- `AlgebraicGeometry.Scheme.isoSpec`: VERIFIED (`X ≅ Spec(Γ⊤)`, `[IsAffine X]`).
- `AlgebraicGeometry.IsAffineOpen.isoSpec`: VERIFIED (`↑U ≅ Spec(Γ U)`) — the actual Need#1 transport handle.
- `CategoryTheory.Abelian.Ext.mapExactFunctor`: VERIFIED — requires `F.Additive`, `PreservesFiniteLimits`, `PreservesFiniteColimits`; an equivalence (whole-scheme transport) satisfies all three, confirming the Q3 distinction from the rejected open-subscheme route.
- `CategoryTheory.Abelian.Ext.covariant_sequence_exact₂` (+ `covariantSequence_exact`): VERIFIED — the covariant LES at fixed 1st arg that Form B / 01EO consume.

## Overall verdict

The strategy is SOUND. Route A's two foundations — `cechAugmented_exact` (resolution) and termwise f_*-acyclicity — are the genuinely irreducible inputs of Leray's acyclicity lemma, not avoidance: the only structurally distinct alternative (01XJ + 02KE) requires strictly more unbuilt Mathlib, so the Leray route is the correct, non-sunk-cost choice. There is no hidden circularity — the whole acyclicity chain bottoms out at P3's purely-algebraic standard-cover Čech vanishing, with 02KG, 01EO, and Form B all independent of the main theorem and of f_*-acyclicity. Need#1's whole-scheme `V≅SpecΓV` Ext transport is sound: it rides an equivalence of module categories through the verified `Ext.mapExactFunctor`, which is categorically distinct from the correctly-rejected open-subscheme `j^*` transport (the restriction-preserves-injectives wall), and the project further sidesteps any ambient→restricted Ext conversion by routing the 01EO seed through the concrete section Čech complex. No infrastructure-deferral findings — every gap (coproduct→product sheaf iso, Need#1, Need#2, the EnoughInjectives connector) is an in-project build with an estimate. The single must-fix is an effort-honesty CHALLENGE on P5a-resolution: reconcile the "01I8-comparable, overran ~7×" risk note with the `~3–5`-iter estimate by decomposing Sub-brick A's stubs or widening the range. Format is DRIFTED on minor points only (inline `iter-056` attributions, dense `## Completed` cells, a rejected route kept inline) — worth trimming but not a blocking restructure.
