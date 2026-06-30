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
| A.1.c.sub — comparison iso on line bundles (loc-triv) | ACTIVE. **DUAL DONE (iter-317):** `DualInverse.lean` sorry-free + axiom-clean — `sliceDualTransport(Inv)`, `dual_restrict_iso`, `dual_isLocallyTrivial` all closed; the route-2 group-inverse C-bridge of the substrate is complete. **D3′ → conjugate-calculus recast** (remaining substrate pole; `key` CLOSED iter-314; the Sq4 4-node chain `pullbackValIso_eq_sheafCompPb`/`sheafCompPb_counit_comp_coherence`/`pullbackValIso_comp` ALL CLOSED axiom-clean iter-319; **iter-320 = close `pullbackTensorMap_restrict`**, the interleaved 4-square assembly paste — all square coherences in-file, Sq3 wired inline, via the ~15–35 s scratch-loop method since LSP times out / builds 9 min): `leftAdjointUniq`=conjugate-of-id (two `rfl` bridges) ⇒ `conjugateEquiv_comp` fusion whose FREE middle adjunction absorbs the intermediate-scheme sheafification (`analogies/d3-mate-recast-309.md`); SUPERSEDES the mirror-the-model `homEquiv` telescope (walled on the sheafification-slide + 3.2M-hb budget). D4′ + group inverse downstream. | ~14–24 | ~80–220 · D3′ recast ~cheap | `isIso_of_isIso_restrict` (D4′); ε-naturality `restrictScalarsLaxε` (dual); `conjugateEquiv_comp`/`_whiskerLeft` (D3′) | DUAL+D3′ both poles; D3′ conjugate recast + DUAL verified `erw`-bridge are the unstick levers |
| A.1.c.fun — RelPic functor on `IsLocallyTrivial` (PARALLEL) | OPENING; author `addCommGroup` + `functorial` vs typed-sorry bridge | ~7–12 | ~350–600 · 0/it | `CommGroup→AddCommGroup` transport; ét-topology on `Over S` | starts vs bridge now; full close gated on A.1.c.sub |
| A.2.c — representability scaffolding | HELD behind A.1.c | ~12–16 | ~600–800 · 0/it | A.1.c | `⟨sorry⟩` constructors discharged by the engine |
| A.2.c-engine — Stacks 02KH flat base change (Kleiman 4.8 Step-1 PREREQUISITE; active front) | **Goal: prove `cech_flatBaseChange` (02KH, separated case — suffices for the projective curve family).** Two routes, both abandon the walled mate-calculus (sheaf-level natIso `e` cocycle — deleted iter-312, zero consumers). **PRIMARY = reduce-to-absolute (strategy-critic iter-312):** FBC is local on `S'` ⇒ reduce to affine `S'=Spec B`, `S=Spec A`, `B` flat over `A`; then it is the MODULE iso `H^i(X,F)⊗_A B ≅ H^i(X_B,F_B)` via the DONE `cech_computes_higherDirectImage` + termwise affine iso + `Module.Flat` (⊗ commutes with Čech-complex homology). Forms NO sheaf comparison map ⇒ the cocycle evaporates AND plausibly bypasses the leaf-1 abstract-left-adjoint wall `pullback_preservesFiniteLimits` (module-level flatness is elementary). **GENERAL-case tool = Čech-to-cohomology SS** (USER-directed; blueprinted iter-312 `lem:cech_to_derived_pushforward_ss` = Grothendieck SS for `i:Mod→PMod` then `Ȟ⁰(𝒰,−)`, built via Čech×resolution bicomplex/`TotalComplex` since Mathlib lacks the Grothendieck SS) — lifts separated→quasi-separated; off the near-term critical path. **Common load-bearing dependency (build first, both routes):** `cechComplex_baseChange_iso` (Stacks 02KG, termwise affine) via the sorry-free `pushforward_spec_tilde_iso`/`pullback_spec_tilde_iso` + `cancelBaseChange` — NOT the canonical mate. Kept opaque (USER): canonical-mate sorries `flatBaseChange_pushforward_isIso`, `affineBaseChange_pushforward_iso`. **Bridge DONE (iter-318, axiom-clean):** `lem:pushPullObj_iso_tilde` = 3 sorry-free decls (`pullback_isQuasicoherent` via `isQuasicoherent_pullback_opens` — NOT `Presentation.map`/QuotScheme, both unsound; alt-1 `pullbackRestrict_iso_tilde`; alt-2 `pushPullObj_pushforward_iso_tilde`) over sorry-free infra (LIVE 01I8 `isIso_fromTildeΓ_of_quasicoherent`; `qcoh_iso_tilde_sections`; `pushforward_iso_preserves_qcoh`; `affinePushforwardPullbackBaseChange`; `IsAffineOpen.biInf`). **iter-319: product-decomposition layer LANDED** — both leaves' degreewise `app` decompose `Yₙ=∐_σ U_σ` via sorry-free `pushPull_sigma_iso`+`PreservesProduct.iso` to a per-σ single-open base change (compiling). **Frontier (iter-320):** (i) the per-σ S-level affine-reduction heart `pushPullObj_coverInter_baseChange` (bridge altitude 2 + affine brick; the genuine multi-hundred-LOC content), (ii) X-level per-σ Beck–Chevalley after adding `[Finite 𝒰'.I₀]`+`[∀i,IsAffine 𝒰'.X i]` to the base-changed cover, (iii) the two naturalities. Delivers the **affine-base** separated case (`cech_flatBaseChange` carries `[IsAffine S][IsAffine S']`; suffices since strata-openness is local on S). General-S = a later locality-on-S' reduction node. | ~6–14 | ~250–600 · — | `Module.Flat` ⊗-exactness commuting with homology; affine reduction of `R^i f_*` to `H^i(X,F)~`; `cancelBaseChange` termwise packaging | over-scope avoided: separated case needs neither the mate calculus nor the full SS |
| A.2.c-engine — strata-openness flattening (Kleiman 4.8 Step-1, alongside 02KH) | **RE-SIGNED iter-306** (soundness): added `[F.IsFinitePresentation]` (Mathlib `SheafOfModules.IsFinitePresentation` → `IsFiniteType`+`IsQuasicoherent`; NOT a project-local `IsCoherent`) to the 7 geometric decls — were FALSE without a coherence hyp. Now true-as-stated; bodies fresh `sorry`. Prover (Nitsure §4 generic flatness — Noether-normalisation + dévissage; needs a Mathlib-gap algebraic core beyond the finite-module case) opens when the front has capacity. | ~8–14 | ~200–500 · — | algebraic generic flatness over a poly ring (Mathlib gap); Nitsure §4 | the algebraic core is a genuine Mathlib gap to build |
| A.2.c-engine — general quasi-separated `Rⁱf_*` / Quot/Cartier (RR-free) | **PAUSED.** `pushPullMap_comp` STUCK 5 iters (kernel whnf pentagon). Strategic re-read: the **separated** 02KH case suffices for the curve/Jacobian application (projective ⇒ separated family), so general quasi-separated `Rⁱf_*` functoriality is OFF the near-term critical path. Revisit only if the quasi-separated lift is forced. | ≈80–135 | ~3000–5000 · 0/it | `Rⁱf_*` (general), Rel Proj, CM-regularity | dominant long-pole, now deferred behind the separated 02KH front |
| A.3 — tangent + Pic⁰ AV-structure | gated A.2.c | ~26–45 | ~1100–2100 · 0/it | scheme tangent space; Hilbert poly | absent in Mathlib; likely under-counted |
| A.4 — Albanese UP (Route 1 RR-free primary) | gated A.2.c | ~12–20 | ~600–1000 · 0/it | Milne 3.2/3.10 rigidity + rational-map extension | Route-2 autoduality contingent (RR-freeness unverified) |
| witness body (uniform Pic⁰ wrap) | gated A.3 | ~5–7 | ~250–450 · 0/it | tangent-iso + connectedness; genus 0 ⇒ Pic⁰=Spec k automatically | hidden A.2.c transit |

**Total Route A**: ~120–230 iters / ~4300–7500 LOC (RR-free engine path; the A.2.c engine dominates
the count — see its row for the reconciled estimate). The ⊗-group law is DONE (`picCommGroup`
axiom-clean). Escalation-to-user is DISABLED (USER autonomous-operation directive): the loop decides
the route and may refactor a dead-end.

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| ⊗-group law on `IsInvertible` | ≤253 | — | Picard/* | `picCommGroup` axiom-clean | carrier = tensor-invertibility, inverse = witness | — |
| Čech-cohomology library (enrich merge) | 261 | ~800–1200 | Cohomology/Cech* | `cech_computes_higherDirectImage`; nerve→complex backbone | `rawPushPullMap` reformulation | `pushPullMap_comp` STUCK→PAUSED (kernel whnf/pentagon) |
| Quot/representability substrate (GR-quot union merge) | 290 | ~? | 5 files (GrassmannianCells/Quot, GlueDescent, GradedHilbertSerre, SectionGradedRing) | `Grassmannian.represents` sorry-free; graded Hilbert–Serre; qcoh-descent (`fromTildeΓ`) into QuotScheme | cell-chart atlas; `glueMorphisms`; localized-module iso criteria | χ-blocked `hilbertPolynomial`/`QuotFunctor` stubs still `sorry`; broken `\cref`s from renames |
| Čech leaf-2 reduction (02KH) | 304 | ~120 | CechHigherDirectImageUnconditional | leaf-2 → single cosimplicial natIso `e`; factoring lemma axiom-clean | cosimplicial `alternatingCofaceMapComplex.mapIso` | `e` is downstream of FlatBaseChange — frontier moved out |

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
duality); regularity from the rational-map-into-AV extension (`Albanese/*`, `RigidityLemma` —
char-free). CONTINGENT = Route 2 (UP via Kleiman `rmk:Alb` on `J^∨`, by autoduality `J^∨≅J` + Galois
descent) — autoduality is classically RR-dependent (theta polarization), UNVERIFIED RR-free; a Milne
§III.6 check (open questions) can promote it. NB: verify Route 1's divisor↔Pic cone is disjoint from
the paused RR chapters (open questions).

**Route C — Riemann–Roch — PAUSED (USER, permanent).** Imported with inline sorries. The RR-free
route (A.2.c engine + A.4 Route 1) discharges ALL THREE protected Goal nodes
WITHOUT RR — RR is never on the critical path to the goal under this architecture. RR would only
unlock the OPTIONAL cheap curve route (a shortcut, not a prerequisite). Pause cost: the ~3400+ LOC
engine and the autoduality contingency exist solely to provide that RR-free path.

**Genus 0 (no separate arm).** Handled uniformly by the Pic⁰ witness: when `genus C = 0`,
`H¹(C,𝒪_C)=0` so `Pic⁰_{C/k}=Spec k` automatically. The former direct `J := Spec k` Mumford-rigidity
arm — and its whole `RigidityKbar`/cotangent/`Differentials`/`Genus0BaseObjects`/genus-0-RR lane —
was **removed** (2026-06-23); the witness is now a single uniform `picardJacobianWitness`. The
genus-0 `RiemannRoch` subproject is correspondingly obsolete (renamed `RiemannRoch-[obsolete]`).
See `memory/genus-split-removed-uniform-pic0.md`.

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
  DE-COUPLED from D3′.** The backbone (geometric nerve `Arrow.augmentedCechNerve` + preadditive
  nerve→complex plumbing) is independent and axiom-clean; the push-pull object/morphism bricks
  `pushPullObj`/`pushPullMap` are axiom-clean. The lone remaining nerve hole — the functor laws
  `pushPullMap_id`/`pushPullMap_comp` — needs ONLY Mathlib's `Pseudofunctor (LocallyDiscrete Schemeᵒᵖ)
  (Adj Cat)` coherences (`conjugateEquiv_pullbackComp_inv`, `conjugateEquiv_pullbackId_hom`,
  `pseudofunctor_{left,right}_unitality`, `pseudofunctor_associativity`), NOT the project-local Sq1
  (the tensor-comparison iso is a disjoint construction). So the engine is a GENUINE independent
  parallel pole AND the dominant rate-limiter (~85–140 iters vs ~15–26 for the whole substrate) —
  weight prover lanes toward it; advance it fully concurrently with the substrate, not gated behind
  Sq1. On-path entry `IsLocallyTrivial⟹IsFinitePresentation` DONE axiom-clean. Per USER directive
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
- **A.4 Route-1 RR-freeness — disjointness check — RESOLVED (iter-272 blueprint-reviewer audit).**
  The Route-A active cone (`Albanese_CodimOneExtension` → Thm32 → AlbaneseUP) DOES `\uses{}` two
  declarations physically defined in `RiemannRoch/WeilDivisor.lean` (a Route-C file):
  `def:order_at_point` (`AlgebraicGeometry.Scheme.RationalMap.order`) and `def:codim1_cycles`
  (`AlgebraicGeometry.Scheme.WeilDivisor`). **Both are sorry-free, `proved=True` DEFINITIONS** (verified
  via the leandag cache) — basic divisor *vocabulary*, NOT paused RR *theorems*. "Route 1 is RR-free"
  means independent of the paused RR **theorems** (Riemann–Roch formula, H¹-vanishing, `OcOfD`
  degree/dimension results), which it remains — the divisor-order/cycle definitions carry no RR content
  and are shared, done substrate. So this is NOT an RR-dependency and does NOT block A.4.a. **Hygiene
  note (non-blocking, deferred):** these two def *blocks* still live in the `RiemannRoch_WeilDivisor.tex`
  chapter, so the DAG shows a cosmetic active→paused-chapter edge. Optional cleanup: relocate the two
  def blocks to a neutral/active chapter (e.g. into `Albanese_CodimOneExtension.tex` or a small shared
  `DivisorVocabulary` chapter) so the cross-route edge disappears — `\lean{}` pins are unchanged, only
  the block's host `.tex` file moves. Not required for correctness; tracked as a tidy-up, not a gate.
  **Forward caveat (strategy-critic iter-272, carry to A.4 build):** the present resolution holds at the
  *definition* level (the cone currently uses only the sorry-free `order`/cycle DEFINITIONS). When Route 1
  is actually built, divisor-sum well-definedness on `Pic⁰` will additionally need the **Pic ≅ Cl
  identification for a smooth curve** (Cartier = Weil on a locally-factorial scheme; Hartshorne II.6.11 /
  Stacks 31.28) — a THEOREM, not vocabulary, also living in the divisor/RR neighborhood. It is still
  RR-*theorem*-free (divisor-class theory, not Riemann–Roch), so the RR-free conclusion survives — but
  **re-run this disjointness check at the THEOREM level** (not just def-level) once the Route-1 cone
  actually acquires the Pic≅Cl edge, to confirm no paused RR theorem is pulled.

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

**New project material.** RigidityLemma, WeilDivisor (general divisor theory), Albanese/*,
Picard/{RelativeSpec, LineBundlePullback, RelPicFunctor, FGAPicRepresentability,
IdentityComponent, Pic0AbelianVariety, QuotScheme, FlatteningStratification, TensorObjSubstrate},
Albanese/AlbaneseUP. Route-1 cone retained reversibly.
