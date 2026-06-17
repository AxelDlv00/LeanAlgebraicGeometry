# Strategy-critic directive — iter-233

Read the strategy below as a fresh mathematician. The strategy was substantially rewritten last iter (carrier pivot to tensor-invertibility). Re-verify soundness, focusing on whether the carrier pivot genuinely dissolves the prior stall and whether the engine de-gating is sound parallelism. Challenge sunk-cost reasoning.

## STRATEGY.md (verbatim)
    # Strategy
    
    ## Goal
    
    Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): the nine
    protected declarations headed by `AlgebraicGeometry.Jacobian` and
    `Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over the `k`-rational
    pointing of a smooth proper geometrically irreducible curve `C/k` (`[Field k]` only; no `C(k)≠∅`,
    no `CharZero`). `J := Pic⁰_{C/k}` is built unconditionally; only `isAlbaneseFor` is quantified over
    the pointing. End-state: zero inline `sorry` in the dependency cone of each protected decl, 0
    project axioms, kernel-only axioms. Spine: pointed vs. unpointed.
    
    Posture is **option (c)**: forward the Route-A Picard substrate while Riemann–Roch stays frozen by
    the USER ROUTE C PAUSE. The nine decls typecheck modulo named sorry-axioms (0 project axioms; none
    yet kernel-clean).
    
    ## Phases & estimations
    
    | Phase | Status | Iters left | LOC (rem · /it) | Key Mathlib needs | Risks |
    |---|---|---|---|---|---|
    | A.1.c.SubT — ⊗-group law (carrier pivot to `IsInvertible`) | re-architecting onto tensor-invertibility (inverse free); dual route demoted to deferred bridge | ~3–5 | ~150–250 · ~0/it | invertibility-carrier `CommGroup`; flat-whiskering associator for invertible modules; re-base `OnProduct`/RPF onto `IsInvertible` | associator currently sorry-transitive via flatness-free whiskering — bypassed by restricting to flat (=invertible) modules |
    | A.1.c — RelPic functor | held (placeholder bodies) | ~3–5 | ~50–150 · 0/it | iso-class group; ét-sheafify on `Over S` | RE-ENGAGE: replace dishonest `PicSharp := const PUnit` + `functorial := 0` |
    | A.2.c — representability (scaffolding) | priority-2 | ~12–16 | ~600–800 · 0/it | A.1.c | `⟨sorry⟩` constructors discharged only by the engine below |
    | A.2.c-engine — Quot/Cartier (RR-free) | HOLD; first ungated sub-lane being seeded for parallelism: `Cohomology_FlatBaseChange` (i=0 flat base change, Stacks 02KH) | ~30–60 | ~3400–5500 · 0/it | R^i f_* (i≥1), Relative Proj, CM-regularity, flattening | largest build; 2–4× cheaper RR route behind the pause; engine-coverage seeding is the USER parallelism work |
    | A.3 — tangent + Pic⁰ AV-structure | gated A.2.c | ~26–45 | ~1100–2100 · 0/it | scheme tangent space; Hilbert poly | absent in Mathlib; likely under-counted |
    | A.4 — Albanese UP (Route 2) | gated A.2.c; autoduality RR-freeness UNVERIFIED | ~12–20 | ~600–1000 · 0/it | `rmk:Alb` + autoduality `J^∨≅J` + Galois descent | if autoduality needs RR, collides with Route C |
    | genusZero + witness body | gated A.3 | ~5–7 | ~250–450 · 0/it | tangent-iso + connectedness | hidden A.2.c transit |
    
    **Total Route A**: ~95–180 iters / ~4300–7500 LOC (RR-free engine path). The ⊗-inverse substrate block
    (C-bridge re-scoped to a SHORT objectwise lemma; ~150–300 LOC remaining) is the sole ungated lane.
    Escalation-to-user is DISABLED (USER autonomous-operation directive): the loop decides the route
    autonomously and may refactor a dead-end. The RR-fork remains an FYI only.
    
    ## Routes
    
    `J := Pic⁰_{C/k}` (Kleiman §4–5, Nitsure §5, Milne III §6). Bottom-up (USER): ungated roots first,
    no gated target before its roots, no A.3+ before A.2.c. Every directive cites
    Kleiman/Nitsure/Milne/Mumford/Hartshorne/Stacks. **Critical path (RR-free):** A.1.c.SubT →
    A.1.c → A.2.c.
    
    **A.1.c.SubT — group law via the tensor-invertibility carrier.** `Pic X` = the commutative group of
    iso-classes of **invertible** `𝒪_X`-modules under ⊗, where invertible means tensor-invertible:
    `IsInvertible M := ∃ N, Nonempty (M ⊗ N ≅ 𝒪_X)` (Stacks 0B8M/01CX — the definition of an invertible
    module; equivalent to locally-free-rank-1 on any ringed space). Carrying the group on THIS predicate
    makes the group axioms near-trivial: identity `[𝒪_X]`; closure from associator+braiding; **inverse
    `[M]⁻¹ := [N]` is the membership witness — free, no inverse object to construct**; inverse
    well-defined since `N` is determined up to iso (`N ≅ N⊗𝒪 ≅ N⊗(M⊗N') ≅ 𝒪⊗N' ≅ N'`). `CommRing.Pic`
    (= `Skeleton (Module.Invertible R)`) is NOT reusable (it reads its group off a coherent
    `MonoidalCategory` over a FIXED ring, unavailable for the varying `𝒪_X`), so the `CommGroup` is built
    by hand from existence-of-iso lemmas; pentagon/coherence is never invoked. The restriction linchpin
    `tensorObj_restrict_iso`, unitors, and braiding are axiom-clean.
    **Why this dissolves the 14-iter stall:** the old route carried the group on the *locally-trivial*
    predicate, which forces manufacturing an inverse object (the internal-hom dual `Scheme.Modules.dual`,
    or cocycle gluing) — that manufacture (`exists_tensorObj_inverse`, via the C-bridge `dual_restrict_iso`)
    is the stuck work. On the invertibility carrier the inverse is the witness, so the entire dual /
    internal-hom apparatus drops off the group's critical path.
    **Remaining gaps (carrier pivot).** (1) `mul_assoc` needs `tensorObj_assoc_iso`; the current general-`M`
    associator is sorry-transitive through the vestigial flatness-FREE whiskering (`W_whisker*_of_W` →
    `isLocallyInjective_whiskerLeft_of_W`). **Fix:** restrict the associator to invertible modules, which are
    locally free ⟹ flat, so the clean flat-whiskering lemmas (`W_whisker*_of_flat`) apply and the
    flatness-free sorry is bypassed. (2) Re-base the relative-Picard consumer (`LineBundle.OnProduct`,
    `RelPicFunctor`, `addCommGroup_via_tensorObj`) from `IsLocallyTrivial` onto `IsInvertible` (cheap — they
    are unbuilt placeholder stubs). (3) `IsInvertible ⟺ IsLocallyTrivial` (Stacks 0B8M) is a *deferred
    bridge*, built only when a downstream consumer specifically needs local triviality.
    **Deferred (off the group's critical path):** the dual object + C-bridge `dual_restrict_iso` +
    `exists_tensorObj_inverse` (the `IsLocallyTrivial ⟹ IsInvertible` direction) — retained as the deferred
    bridge, NOT a blocker. **Dead ends:** routing the dual base-change through `overSliceSheafEquiv`; the
    sheafify-the-presheaf associator/eval shortcut (re-hits `M ◁ η` whiskering).
    
    **A.2.c — representability + Quot fork (held).** Six Prop-valued typeclasses with `⟨sorry⟩`
    constructors scaffold representability (~600–800 LOC); Route A proceeds under them. Discharge fork:
    RR-free general Quot/Hilbert engine (Nitsure §5 + Kleiman §4, ~3400–5500 LOC, all Mathlib-absent;
    deepest root `R^i f_*`, i≥1) vs cheap curve route (Kleiman §5, `Sym^n`/Abel–Jacobi, ~600–1000 LOC,
    needs paused RR). Engine HELD behind A.1.c.SubT→A.1.c.
    
    **Albanese UP — Route 2.** UP from `Pic` representability via Kleiman `rmk:Alb` (RR-free) on the
    dual `J^∨`, landed on `J` by autoduality `J^∨≅J` (Milne 6.6 / EGK 2.1) + Galois descent `k̄→k`
    (Milne 6.4). Supersedes the Route-1 codim cone, retained reversibly with the deletion gate closed
    until autoduality RR-freeness is re-verified (theta divisor rests on RR — top risk).
    
    **Route C — Riemann–Roch — PAUSED (USER).** Imported with inline sorries (option c). Needed at the
    three Goal nodes; would unlock the cheap curve route. Pause cost: the ~3400+ LOC engine and the
    autoduality risk exist solely to avoid RR.
    
    **Genus-0 arm.** (a) Route-A Pic⁰-via-AV-wrap (transits A.2.c); (b) direct `J := Spec k` via Mumford
    rigidity — substrate partial, PAUSED (USER).
    
    ## Open strategic questions
    
    - **Group-law carrier = tensor-invertibility (DECIDED).** Carry `Pic X` on `IsInvertible`
      (`∃N, M⊗N≅𝒪`, Stacks 0B8M), not on locally-triviality. The inverse becomes the membership witness
      (free); the dual / internal-hom / `dual_restrict_iso` / `exists_tensorObj_inverse` drop off the
      critical path and become a deferred `IsInvertible⟺IsLocallyTrivial` bridge. Reversing signal: a
      downstream consumer that provably requires the locally-trivial carrier and cannot accept invertibility.
    - **Associator on invertible modules.** `mul_assoc` needs a sorry-clean `tensorObj_assoc_iso`; the
      general-`M` version is sorry-transitive via flatness-free whiskering. Restrict to invertible (⟹ flat)
      modules so the clean `W_whisker*_of_flat` lemmas apply.
    - **Engine foundations run in PARALLEL with the substrate (DECIDED).** The A.2.c engine foundations
      (`R^i f_*`, Relative Proj, CM-regularity, flattening, Quot representability, relative Cartier, flat
      base change) do NOT depend on the group law; de-gate them from A.1.c.SubT and seed blueprint coverage
      now (first lane: `Cohomology_FlatBaseChange`, Stacks 02KH).
    - **Cost asymmetry (FYI; divisor arm gated by the permanent ROUTE C PAUSE, not autonomously reachable):**
      divisor route ≈ Kleiman §5 (~600–1000 LOC) + the paused RR chain (cohomology of smooth proper curves over
      a general field, no CharZero; Serre duality + `H¹` vanishing + RR formula — Mathlib-absent, ~2000–4000 LOC)
      vs. the RR-free engine (~3400–5500) + the ~150–300 substrate remaining. The arms are closer than "~5×
      cheaper" once the RR chain is numbered. The divisor arm needs the USER to lift ROUTE C PAUSE; until then
      the loop completes the RR-free substrate.
    - **Autoduality `J^∨≅J` RR-freeness** (EGK 2.1 / Poincaré bundle): second-verify before any Route-2
      investment — classically RR-dependent.
    - **`k̄→k` Galois descent** at the no-`C(k)` heart: verify per-pointing `isAlbaneseFor` composes
      with descent + autoduality before treating it as minor.
    - **`R^i f_*` (i≥1)** (gates the engine): Mathlib PR vs project Čech build (~800–1200) vs typed-sorry
      pin. Decide when the engine de-gates.
    
    ## Mathlib gaps & new material
    
    **Gaps to fill (Route A).**
    - A.1.c.SubT: restrict-iso linchpin + dual object `Scheme.Modules.dual` + B-connector + both
      module-transport shadows (`homMk`, `restrictScalarsRingIsoDualEquiv`) + the **shared root**
      `overSliceSheafEquiv` (the open-immersion↔slice sheaf-site equivalence, named Mathlib TODO) all CLOSED
      axiom-clean. **Remaining gaps:** wire the root into the two consumers — the A-engine `homOfLocalCompat`
      (gluing via `presheafHom`+`existsUnique_gluing`+`presheafHomSectionsEquiv`+`homMk`) and the dual
      restrict-iso `dual_isLocallyTrivial` (via `overSliceSheafEquiv`+`restrictScalarsRingIsoDualEquiv`), then
      assemble `exists_tensorObj_inverse`; then the by-hand `CommGroup` (`tensorObjIsoclassCommMonoid`).
      Dead-end (do NOT re-attempt): sectionwise flatness from invertibility; **route-(e) d.2 stalk-⊗ — now
      AVOIDED by the descent re-route, not built**; the canonical-presheaf shortcut (sheafify the presheaf
      associator/eval — re-hits the `M◁η` whiskering = d.2); free-cover-avoids-H1; bundled fixed-base
      monoidal; the whiskering/stalk monoidal-localizer apparatus (vestigial — delete once the descent
      re-route lands; still backs the current `tensorObj_assoc_iso` proof).
    - A.1.c: ét-sheafify on `Over S`; `OnProduct` re-point to the locally-trivial subtype.
    - A.2.c-engine (HELD): `R^i f_*` (i≥1), Relative Proj, geometric Hilbert poly, CM-regularity,
      semi-continuity, flattening, Grassmannian, Quot representability, relative Cartier (~3400–5500).
    - A.3 / A.4: scheme tangent space, Hilbert poly, Pic⁰ AV-structure; `rmk:Alb` UP, autoduality,
      Galois descent.
    
    **New project material.** AbelianVarietyRigidity, RigidityLemma, Genus0BaseObjects/*, RiemannRoch/*
    (paused), Picard/{RelativeSpec, LineBundlePullback, RelPicFunctor, FGAPicRepresentability,
    IdentityComponent, Pic0AbelianVariety, QuotScheme, FlatteningStratification, TensorObjSubstrate},
    Albanese/AlbaneseUP. Route-1 cone retained reversibly behind the closed deletion gate.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected declarations headed by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over the k-rational pointing of a smooth proper geometrically irreducible curve C/k ([Field k] only). J := Pic⁰_{C/k} built unconditionally; isAlbaneseFor quantified over the pointing. End: zero inline sorry in the cone of each protected decl, 0 project axioms.

## References index (summary)
Kleiman "The Picard scheme" (FGA) — Route A source (§4 existence, §5 Pic⁰, §6 Pic^τ). Nitsure "Hilbert and Quot Schemes" (FGA) — Quot engine. Milne "Abelian Varieties" — rigidity, Thm 3.2, Albanese UP. Mumford "Abelian Varieties". Stacks Project tags (01CR/01CX/0B8M invertible modules; 02KH flat base change; 035U/0BUG geom-reduced). Hartshorne. Full table in references/summary.md.

## Blueprint chapter titles (one line each)
Picard_TensorObjSubstrate (⊗-group law via IsInvertible carrier — the rewritten chapter), Picard_RelPicFunctor, Picard_FGAPicRepresentability, Picard_QuotScheme, Picard_FlatteningStratification, Picard_RelativeSpec, Picard_LineBundlePullback, Picard_IdentityComponent, Picard_Pic0AbelianVariety, Cohomology_FlatBaseChange (02KH i=0), Cohomology_HigherDirectImage (R^i f_*), Cohomology_MayerVietoris, Cohomology_SheafCompose, Cohomology_StructureSheaf{Ab,ModuleK}, Albanese_AlbaneseUP, Albanese_Thm32RationalMapExtension, Albanese_CodimOneExtension, Albanese_AuslanderBuchsbaum, AbelianVarietyRigidity, RigidityKbar, RiemannRoch_* (PAUSED), Jacobian, Genus, AbelJacobi.

## Your job
SOUND / CHALLENGE / REJECT with specifics. Key questions: (1) Is carrying Pic on `IsInvertible M := ∃N, M⊗N≅𝒪` (inverse = witness) the right move vs the demoted locally-trivial+dual route? (2) Is restricting the associator to invertible(=flat) modules to bypass the flatness-free whiskering sorry sound? (3) Is de-gating the cohomology engine (R^i f_*, flat base change) to run parallel with the group law sound, given A.2.c representability needs both? (4) Any cheaper path to Pic representability being missed?
