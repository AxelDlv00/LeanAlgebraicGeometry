# Strategy

## Goal
Formalize Kemeny, *Universal secant bundles and syzygies of canonical
curves* (MR4213770, arXiv:2003.05849). Final theorems:
`thm:kemeny_generic_green` — Generic Green's conjecture: \(\K_{k,1}(C,\omega_C)=0\)
for a general complex curve of genus \(2k\) or \(2k+1\); and the even-genus
Geometric Syzygy Conjecture (`cor:kemeny_geometric_syzygy_even`).

## Phases & estimations
| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|-------|--------|-----------|-----|-------------------|-------|
| P0b Eval-map substrate → `M_L` kernel bundle → `K_{p,q}` (Foundations + Basic) | ACTIVE | 4–9 | ~300–700 | evaluation morphism `H⁰(L)⊗𝒪_X → L` (counit of free⊣Γ, or direct); trivial bundle `V⊗𝒪_X` from `SheafOfModules.free`; `kernel` in abelian `X.Modules`; scalar `H^i` (done) + `∧^i` (done) to phrase `K_{p,1}=0 ⇔ H¹(∧^{k+1}M_L)=0` | eval morphism is the one genuinely new construction; `V⊗𝒪_X` packaging; rank/locally-free of `M_L` |
| P1 Even-genus Voisin (sec1): kernel-bundle red.→`thm:kemeny_even_voisin` | NEXT | 15–40 | ~1k–3k | Koszul cohomology \(\K_{p,q}\), \(R^if_*\), Grauert, blow-up, Sym/∧ of bundles, Künneth | massive Mathlib gap; most infra absent |
| P2 Geometric syzygy even genus (sec2): →`cor:kemeny_geometric_syzygy_even` | NEXT | 15–40 | ~1k–3k | Serre duality, det of bundles, Veronese, \(W^1_{k+1}\) Brill–Noether | depends on P1; Brill–Noether loci absent in Mathlib |
| P3 Odd-genus Voisin (odd-genus): →`thm:kemeny_odd_voisin` | NEXT | 20–50 | ~1.5k–4k | Pic-rank-2 K3 lattice, relative tangent/Euler, elementary transform, Petri generality | longest arc; depends on P1/P2 machinery |
| P4 Main syntheses: `thm:kemeny_generic_green`, transfer lemmas | NEXT | 3–8 | ~200–500 | semicontinuity in flat families, K3→curve restriction | thin once P1–P3 land |

Estimates are coarse and large by design: this is near-research-frontier
algebraic geometry. Part of the cohomology/bundle SUBSTRATE is present in Mathlib —
`AlgebraicGeometry.Scheme.Modules` is abelian (native kernels/cokernels/SES),
`pushforward` is an additive functor, `Functor.rightDerived` gives abstract R^i once
the category has injective resolutions, `ShortComplex.ShortExact` exists, and
stalk-locality is already a theorem (the thin concrete defs of the interface).
But TWO foundational pieces are genuine project-built developments, not thin ports
(see Mathlib gaps): the injective-resolution BRIDGE for `R^if_*`
(`IsGrothendieckAbelian X.Modules`) and the exterior/symmetric POWER functors on
`X.Modules` — Mathlib has neither for sheaves of modules over a varying ring sheaf.
Scalar `H^i`, by contrast, takes the LIGHT route through Ab-valued sheaves on opens,
where the Grothendieck-abelian structure is free from Mathlib.
The interface lives in its own `Foundations.lean` (covered by
`Kemeny_PeerDependencies.tex`) so it gates independently of the deep paper proofs.
The higher infrastructure (Koszul cohomology, secant bundles, K3 Picard lattices) is
built project-side via `mathlib-build` lanes, one lemma at a time.

## Completed
| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|-------|----------------------|-----|-------|-------------|---------------------|----------|
| P0a Foundations cohomology+power substrate (two-tier H^i/R^if_* bridge; ∧^i/Sym^i on `X.Modules`) | 013 · 8 (iters 006–013) | ~1110 | `Foundations.lean` / `Kemeny_PeerDependencies.tex` | light `H^i` (Ab-sheaf derived Γ) + heavy `IsGrothendieckAbelian X.Modules` (AB5+separator via `freeYoneda`); openwise+sheafified `Scheme.Modules.{exterior,sym}Power` via base-change power maps over semilinear restriction | sheafify via `sheafificationAdjunction (𝟙 R.obj)`; base-change power map over semilinear `R.map f`; `restrictScalars{Id',Comp'}` coherence for `mk`; per-open `CommRing` via `ringCatSheaf_commRing` (reducible `letI`) | global `SheafOfModules.free` DEAD END (sees only Γ); Sym universe-index by `ULift (Fin i)`; `Module A N` diamond won't synth — explicit binders; `mk` coherence `whnf` cost → `maxHeartbeats` bumps |

## Routes
Single route — follow the paper's three-part structure (even-genus Voisin
via universal secant bundles → even geometric syzygy → odd-genus Voisin via
the Picard-rank-two nodal-K3 reduction), then assemble the two headline
theorems. No alternative route is competitive: the secant-bundle method *is*
the paper's contribution and the blueprint already tracks it section by
section.

## Open strategic questions
- Two-tier cohomology bridge: scalar `H^i` derives in `TopCat.Sheaf Ab X` (the
  essentially-small lemma applies — Grothendieck-abelian structure free), so the headline
  `\K_{k,1}=0 ⇔ H¹(∧^{k+1}M_L)=0` does NOT wait on the heavy gap. The heavy bridge
  `IsGrothendieckAbelian X.Modules` (= AB5+separator for `SheafOfModules`) is needed only for
  `R^if_*` (relative/family args, P1+). Open: confirm the light `H^i` agrees with the
  module-category one where both apply (standard, but verify when assembling P1).
- \(\K_{p,q}(X,L)\) modelling: M_L = `kernel` (in abelian `X.Modules`) of eval
  `H⁰(L)⊗O_X → L`; \(\K_{k,1}=0\) ⇔ a Prop about `H¹(∧^{k+1}M_L)`. Concrete def,
  not opaque. Needs scalar H^i (light route) and ∧^i (project-built power functor) first.
- Eval-map substrate buildability (P0b, ACTIVE): is the evaluation morphism
  `H⁰(L)⊗𝒪_X → L` cheapest as the counit of a free⊣Γ adjunction, or built directly
  from `SheafOfModules.free` + the eval on sections? `V⊗𝒪_X` packaging (free module on a
  k-basis of H⁰(L)) vs a constant-sheaf tensor. Resolve before scaffolding `kernelBundle`.
- Foundations parallelism: once the bridge instance + the H^i/R^if_*/∧^i/Sym^i/
  locally-free defs land, the named higher gaps are mutually independent and shared
  across P1–P4; the P1→P2→P3 ordering is NOT a true critical path — front-load parallel
  `mathlib-build` lanes.
- Lean file structure: foundational substrate split into `Foundations.lean`
  (covered by `Kemeny_PeerDependencies.tex`); `Basic.lean` keeps the even-genus
  geometric defs (covered by `Kemeny_UniversalSecantBundles.tex`). Split per-phase
  files further as P1–P3 content lands.

## Mathlib gaps & new material
Gaps to fill. LIGHT bridge (do first — unblocks scalar `H^i`): `HasInjectiveResolutions
(TopCat.Sheaf Ab X)` via `Sheaf.isGrothendieckAbelian_of_essentiallySmall` (Ab-valued
sheaves on the essentially-small site of opens ARE `Sheaf J A`, so the lemma applies) ⇒
enough injectives ⇒ resolutions; redefine `H^i(X,F)` as derived global sections of the
underlying Ab-sheaf. HEAVY bridge (P1+, for `R^if_*` in the module category):
`IsGrothendieckAbelian X.Modules` — the essentially-small lemma does NOT apply here
(`X.Modules = SheafOfModules` over a *varying* ring sheaf, not `Sheaf J A`); build
`AB5OfSize (SheafOfModules R)` (prove `AB5OfSize (PresheafOfModules R)` objectwise in
`ModuleCat`, transport across the exact sheafification left adjoint) + `HasSeparator
(SheafOfModules R)` (coproduct of `SheafOfModules.free` is a separator) → assemble the 4
`IsGrothendieckAbelian` fields (2 hold by `inferInstance`). `∧^i`/`Sym^i` on `X.Modules`
are BOTH gap-class (no power functor for (pre)sheaves of modules in Mathlib): build the
power functor on `PresheafOfModules R` objectwise via `ModuleCat.exteriorPower`/`Sym` +
functoriality over restriction, then sheafify (Sym additionally lacks even a
ModuleCat-level functor — build that too). Plus: additive `Γ_Ab` (done); base change
(done); locally-free PREDICATE (done); Grauert local-freeness; Koszul \(\K_{p,q}\);
blow-up + exceptional divisor; rel. Euler/tangent; Serre/relative duality; Brill–Noether \(W^1_{k+1}\).
New project material: M_L kernel bundle, K_{p,q}, Lazarsfeld–Mukai bundle \(E\),
universal zero locus \(\cZ\), universal secant bundles \(\cS,\Gamma\), cokernel bundle
\(\mathcal W\), odd kernel bundle \(N\), elementary transform \(S\), Veronese identification.
