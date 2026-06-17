# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): the nine
protected declarations headed by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over the `k`-rational
pointing of a smooth proper geometrically irreducible curve `C/k` (`[Field k]` only; no `C(k)≠∅`,
no `CharZero`). `J := Pic⁰_{C/k}` is built unconditionally; only `isAlbaneseFor` is quantified over
the pointing. End-state: zero inline `sorry` in the dependency cone of each protected decl, 0
project axioms, kernel-only axioms. Spine: pointed vs. unpointed. Posture **option (c)**: forward
the Route-A Picard substrate while Riemann–Roch stays frozen by the permanent USER Route-C pause.

## Phases & estimations

| Phase | Status | Iters left | LOC (rem · /it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| A.1.c.sub — comparison iso on line bundles (loc-triv) | ACTIVE. Remaining: D3′ Sq1 R1/R5 tail then the `pullbackTensorMap_restrict` paste + D4′ chart-chase; dual route-2 `sliceDualTransport` (leg-A built, leg-B ε-iso closed; remaining = add/smul bridge + invFun). Decompose monolithic decls into landable named sub-lemmas | ~8–14 | ~80–250 · ~0/it (monolith metric artifact) | Sq1 comp-coherence; `isIso_of_isIso_restrict` (D4′); `internalHomObjModule`-add bridge (dual) | budget elapsed 26 vs orig ~6–11; monolithic decls mask sub-progress → decompose |
| A.1.c.fun — RelPic functor on `IsLocallyTrivial` (PARALLEL) | OPENING; author `addCommGroup` + `functorial` vs typed-sorry bridge | ~7–12 | ~350–600 · 0/it | `CommGroup→AddCommGroup` transport; ét-topology on `Over S` | starts vs bridge now; full close gated on A.1.c.sub |
| A.2.c — representability scaffolding | HELD behind A.1.c | ~12–16 | ~600–800 · 0/it | A.1.c | `⟨sorry⟩` constructors discharged by the engine |
| A.2.c-engine — Quot/Cartier (RR-free) | Loc-triv entry DONE. `Rⁱf_*` Čech lane OPEN: nerve→complex plumbing DONE axiom-clean; `pushPullObj`/`pushPullMap` bricks DONE axiom-clean (iter-263). Residual = the functor laws `pushPullMap_id`/`pushPullMap_comp`, **DE-COUPLED from D3′** (iter-263 finding): provable from Mathlib's `Pseudofunctor (LocallyDiscrete Schemeᵒᵖ) (Adj Cat)` coherences ALONE (`conjugateEquiv_pullbackComp_inv`, `pseudofunctor_{left,right}_unitality`, `pseudofunctor_associativity`) — NO project Sq1 needed. GENUINE INDEPENDENT parallel pole | ? (≈85–140 at an UNDEMONSTRATED ~40/it; revise once Čech velocity is real) | ~3400–5500 · 0→? /it | `Rⁱf_*` (project Čech ~800–1200), Relative Proj, CM-regularity, flattening | dominant pole; runs fully parallel to the Picard substrate; does NOT reduce total iter count |
| A.3 — tangent + Pic⁰ AV-structure | gated A.2.c | ~26–45 | ~1100–2100 · 0/it | scheme tangent space; Hilbert poly | absent in Mathlib; likely under-counted |
| A.4 — Albanese UP (Route 1 RR-free primary) | gated A.2.c | ~12–20 | ~600–1000 · 0/it | Milne 3.2/3.10 rigidity + rational-map extension | Route-2 autoduality contingent (RR-freeness unverified) |
| genusZero + witness body | gated A.3 | ~5–7 | ~250–450 · 0/it | tangent-iso + connectedness | hidden A.2.c transit |

**Total Route A**: ~120–230 iters / ~4300–7500 LOC (RR-free engine path; the A.2.c engine dominates
the count — see its row for the reconciled estimate). The ⊗-group law is DONE (`picCommGroup`
axiom-clean). Escalation-to-user is DISABLED (USER autonomous-operation directive): the loop decides
the route and may refactor a dead-end.

## Routes

`J := Pic⁰_{C/k}` (Kleiman §4–5, Nitsure §5, Milne III §6). Bottom-up (USER): ungated roots first,
no gated target before its roots, no A.3+ before A.2.c. Every directive cites
Kleiman/Nitsure/Milne/Mumford/Hartshorne/Stacks. **Critical path (RR-free):** A.1.c.sub → A.1.c.fun
→ A.2.c.

**A.1.c.sub — comparison iso on line bundles.** Carry `Pic X` on `IsInvertible M := ∃N, M⊗N≅𝒪`
(Stacks 0B8K/01CX); `picCommGroup` axiom-clean. The substrate prerequisite `IsInvertible.pullback`
reduces to the comparison iso `f^*(M⊗N)≅f^*M⊗f^*N` on loc-triv pairs — δ (`pullbackTensorMap`) upgraded
to an iso via `isIso_of_isIso_restrict` over `{f⁻¹(Uᵢ)}`, each chart reducing to the unit pair via
`pullbackUnitIso` (✓). D1'/D2'/Sq2/Sq2b/Sq3/Sq4 CLOSED; remaining = Sq1 then the
`pullbackTensorMap_restrict` paste + D4' chart-chase. The dual-inverse `exists_tensorObj_inverse` (RPF
group inverse) is an INDEPENDENT parallel workstream taking **route-2** (the shared root is dual-content
-free): `sliceDualTransport` sectionwise = leg-A slice-Hom base-change (`.map` reindex across
`f.opensFunctor`) ∘ leg-B unit ε-iso (~150–250 LOC, self-contained). This single `dual_restrict_iso`
closes the WHOLE remaining inverse chain (A/B descent bridges already closed). Stalkwise is a Plan-B
(needs a fresh `stalkTensorIso`-magnitude build; route-2 is the cheaper linchpin). **Why by-hand:**
`Sheaf.monoidalCategory` needs a FIXED `MonoidalCategory A`; the varying-ring tensor has none.

**A.1.c.fun — relative Picard functor on `IsLocallyTrivial`.** `OnProduct`/`pullbackAlongProjection`
already built+axiom-clean on the `IsLocallyTrivial` carrier (the genuine consumer carrier — RPF
intrinsically classifies loc-triv line bundles). Remaining: `addCommGroup`
— group on loc-triv iso-classes: `map_add` ← the loc-triv comparison iso; `map_zero` ← `pullbackUnitIso`;
inverse ← `exists_tensorObj_inverse`, which **already returns a loc-triv witness**
(`∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (L⊗Linv≅𝒪)`), so group closure stays in the carrier. Then
upgrade `PicSharp.functorial` off the `0` stub; ét-sheafify on `Over S`. Transport modeled
field-for-field on Mathlib `CommRing.Pic.mapAlgebra`/`.functor`. Authored in parallel against a
typed-sorry bridge on the comparison iso (its discharge = A.1.c.sub D4').

**A.2.c — representability + Quot fork (held).** Six Prop-valued typeclasses with `⟨sorry⟩`
constructors scaffold representability (~600–800 LOC); Route A proceeds under them. Discharge fork:
RR-free general Quot/Hilbert engine (Nitsure §5 + Kleiman §4, ~3400–5500 LOC, Mathlib-absent;
deepest root `Rⁱf_*`, i≥1) vs cheap curve route (Kleiman §5, needs paused RR). The Quot embedding
needs `IsInvertible ⟹ coherent locally-free-rank-1`; its cost is UNRESOLVED (see open questions) and
on the A.2.c critical path — decided at A.2.c entry, conservatively budgeted as possibly Mathlib-scale.

**A.4 — Albanese UP.** PRIMARY = Route 1 (RR-free, substrated in-tree): Weil's `φ:Pic⁰→A` via the
divisor-sum map; well-definedness from `Mor(ℙ¹,A)` constant (Milne 3.2/3.10, bare rigidity, no Serre
duality); regularity from the rational-map-into-AV extension (`Albanese/*`, `AbelianVarietyRigidity` —
char-free). CONTINGENT = Route 2 (UP via Kleiman `rmk:Alb` on `J^∨`, by autoduality `J^∨≅J` + Galois
descent) — autoduality is classically RR-dependent (theta polarization), UNVERIFIED RR-free; a Milne
§III.6 check (open questions) can promote it. NB: verify Route 1's divisor↔Pic cone is disjoint from
the paused RR chapters (open questions).

**Route C — Riemann–Roch — PAUSED (USER, permanent).** Imported with inline sorries. The RR-free
route (A.2.c engine + A.4 Route 1 + genus-0 arm (a)) discharges ALL THREE protected Goal nodes
WITHOUT RR — RR is never on the critical path to the goal under this architecture. RR would only
unlock the OPTIONAL cheap curve route (a shortcut, not a prerequisite). Pause cost: the ~3400+ LOC
engine and the autoduality contingency exist solely to provide that RR-free path.

**Genus-0 arm.** (a) Route-A Pic⁰-via-AV-wrap (transits A.2.c); (b) direct `J := Spec k` (Mumford
rigidity) — PAUSED (USER).

## Open strategic questions

- **`IsInvertible ⟹ locally-free-rank-1` (Quot embedding, A.2.c) — RESOLVED (`analogies/engine252.md`).**
  The LITERAL statement is the off-path Mathlib-scale spreading-out (do NOT build). The Quot embedding
  consumes a `Pic⁰` point already `IsLocallyTrivial`, so the cheap `IsLocallyTrivial ⟹ IsFinitePresentation`
  (~120–250 LOC) suffices — blueprinted (`Picard_LineBundleCoherence.tex`). First-iter de-risk: the
  `J.over X` site instances for `X.ringCatSheaf`. Do NOT open a lane on the `IsInvertible` entry point.
- **Group-law carrier = tensor-invertibility (DECIDED; group law DONE).** `IsInvertible`, not
  loc-triviality; inverse = witness. Reversing signal: a consumer that provably requires the loc-triv
  carrier and cannot accept invertibility.
- **RPF carrier = `IsLocallyTrivial` (DECIDED on merits).** RPF intrinsically classifies loc-triv line
  bundles, so `OnProduct` is `{M // IsLocallyTrivial M}`; its `map_add` consumes the comparison ISO
  (not a bare Prop; `CommRing.Pic.mapAlgebra` template). Reversing signal: D3' proves materially harder
  than its proven unit analog `pullbackObjUnitToUnit_comp` (then decompose D3' further; do NOT revive
  the general Lan build).
- **Engine foundations run in PARALLEL with the substrate — and the `Rⁱf_*` hard step is now
  DE-COUPLED from D3′ (iter-263 finding, refutes the iter-262 coupling belief).** The backbone
  (geometric nerve `Arrow.augmentedCechNerve` + preadditive nerve→complex plumbing) is independent and
  axiom-clean; the push-pull object/morphism bricks `pushPullObj`/`pushPullMap` are now axiom-clean too.
  The lone remaining nerve hole — the functor laws `pushPullMap_id`/`pushPullMap_comp` — needs ONLY
  Mathlib's `Pseudofunctor (LocallyDiscrete Schemeᵒᵖ) (Adj Cat)` coherences
  (`conjugateEquiv_pullbackComp_inv`, `conjugateEquiv_pullbackId_hom`, `pseudofunctor_{left,right}_unitality`,
  `pseudofunctor_associativity`), NOT the project-local Sq1. So the engine is a GENUINE independent
  parallel pole — its lane can advance fully concurrently with the Picard substrate, not gated behind
  Sq1. Plan implication: dispatch the `pushPullMap_id`/`pushPullMap_comp` fine-grained pass NOW; no Sq1
  sequencing. On-path entry `IsLocallyTrivial⟹IsFinitePresentation` DONE axiom-clean. Per USER directive
  #6: A.2.c bottom-up, no A.3+.
- **Autoduality `J^∨≅J` RR-freeness — run the Milne §III.6 check at A.2.c entry, not 50 iters out.**
  Decides whether Route 2 can be promoted; Route 1 (RR-free) is primary meanwhile, so `isAlbaneseFor`
  is reachable either way.
- **`k̄→k` Galois descent** at the no-`C(k)` heart: verify per-pointing `isAlbaneseFor` composes with
  descent before treating it as minor.
- **`Rⁱf_*` (i≥1)** (gates the engine): DEFAULT = project Čech build (~800–1200 LOC), the only
  externally-unblocked option (a Mathlib PR supersedes if it lands; typed-sorry pin only if Čech proves
  Mathlib-scale). The dominant engine pole, group-law-INDEPENDENT — its lane must run in PARALLEL with
  the substrate finish, not behind it (blueprint `Cohomology_CechHigherDirectImage` authored; broken
  internal refs being repaired, then file-skeleton scaffold).
- **A.4 Route-1 RR-freeness — disjointness check (verify at A.4 entry).** The divisor-sum map presupposes
  a divisor↔Pic⁰ dictionary (`𝒪_C(D)`); confirm the Route-1 cone does NOT transitively pull a paused
  `RiemannRoch_{WeilDivisor,OcOfD}` decl, else "Route 1 is RR-free" is false. Relocate the needed
  divisor↔Pic decls out of the paused cone if so. Not active (A.4 gated behind A.2.c).

## Mathlib gaps & new material

**Gaps to fill (Route A).**
- A.1.c.sub dual route-2 (`exists_tensorObj_inverse` → RPF inverse): build `sliceDualTransport`
  sectionwise by hand — leg-A slice-Hom base-change (`.map` reindex across `f.opensFunctor`) ∘ leg-B
  unit ε-iso `inv (ε (restrictScalars g))`, `g` at the `CommRingCat` level (frictions resolved,
  `analogies/ma-legb262.md`). Self-contained in `DualInverse.lean`. (The shared root `overEquivalence`
  closed the engine but is dual-content-free, so it is NOT the dual's root.)
- A.1.c.sub comparison iso — upgrade δ (`pullbackTensorMap`, ✓) to an iso via `isIso_of_isIso_restrict`.
  Sq2/Sq2b/Sq3/Sq4 DONE; remaining = Sq1 `sheafificationCompPullback_comp` then the
  `pullbackTensorMap_restrict` paste + the D4' chart-chase.
- A.1.c.fun: `CommGroup→AddCommGroup` transport of `picCommGroup`; ét-topology on `Over S`.
- A.2.c engine FlatBaseChange affine close: scalar transport via `algebraize [φ.hom]`; aligns to upstream
  `isIso_fromTildeΓ_pushforward` (post-pin); `#37189` bump would collapse it but is deferred.
- A.2.c engine (HELD): `Rⁱf_*` (i≥1), Relative Proj, Hilbert poly, CM-regularity, semi-continuity,
  flattening, Grassmannian, Quot representability, relative Cartier (~3400–5500); `IsInvertible ⟹
  loc-free-rank-1` coherence bridge (cost unresolved, above).
- A.3 / A.4: scheme tangent space, Hilbert poly, Pic⁰ AV-structure; `rmk:Alb` UP, autoduality, Galois
  descent.

**New project material.** AbelianVarietyRigidity, RigidityLemma, Genus0BaseObjects/*, RiemannRoch/*
(paused), Picard/{RelativeSpec, LineBundlePullback, RelPicFunctor, FGAPicRepresentability,
IdentityComponent, Pic0AbelianVariety, QuotScheme, FlatteningStratification, TensorObjSubstrate},
Albanese/AlbaneseUP. Route-1 cone retained reversibly.
