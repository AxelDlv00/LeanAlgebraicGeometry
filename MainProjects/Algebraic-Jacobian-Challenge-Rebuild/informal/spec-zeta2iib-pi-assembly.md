# Brick spec — ζ2·ii-b: the pi-assembly (G4–G6)

*Written 2026-07-14 (Fable orchestrator). Consumer: one Fable implementation agent —
this is the subtlest remaining ζ2 step; the deliverable CONTRACT below is binding, the
interface decomposition and proof route are yours to design.*

## Mission

From an Amitsur-coherent Čech witness and a trivializing basic cover, build the composite
descent unit of the (C1) assembly:

**Deliverable contract.** In the ζ1/ζ2 setting (`k → A → B`, `𝒩`/`γ` a unit cocycle on
`Spec B` presenting `N`, `θ' : CoherentCechWitness k A B 𝒩 γ`), given a finite basic
cover `f : ι → B` with `Away` models `S i` trivializing `N` (in the sense of the landed
dictionary: a trivializing family with cover cocycle `c` whose `cocycleUnit` presents the
class of `N` — reuse the `CechPicSurjective`/`PicAffineCover` machinery, restated as
hypotheses if cleaner), produce with `P := ∀ i, S i`:

1. (G4/G5) `v : (P ⊗[A] P)ˣ` with `Module.IsDescentCocycle v` — components
   `v i j ∈ (S i ⊗[A] S j)ˣ` extracted from `θ'` restricted to the basic opens
   `D((r i ⊗ 1)(1 ⊗ r j))` of `Spec (B ⊗[A] B)` and corrected by the trivializations;
   assembled through `Algebra.TensorProduct.piDoubleEquivA`; the cocycle identity from
   `θ'.coherent` + the trivialization telescoping, transported through
   `piTripleEquivA` (the descent-face transport lemmas are landed).
2. (G6) `Units.map (Module.tensorCollapse A B P).toRingHom.toMonoidHom v = cocycleUnit c`
   (up to the landed `R_B ≅ B` bookkeeping — state the cleanest faithful form), so that
   ε2 (`Module.IsDescentCocycle.picClass_collapse`) hands
   `CommRing.Pic.mapAlgebra A B (picClass v) = pic N` to ζ3 for free.

## READ FIRST (binding order)

1. `informal/zeta2ii-api-recon.md` — ALL sections; it maps every existing declaration
   with file:line (dictionary chain §1, descent layer §2, section rings §3, θ-to-units
   bridge §4, gap list §5 G4–G6). It was verified against the tree on 2026-07-13.
2. `informal/c1-etale-separatedness-assembly.md` §ζ2·ii and the "Original prose route".
3. The landed interfaces: `Algebra/TensorAway.lean`, `Algebra/TensorAwayPi.lean` (G1–G3,
   G7 — your algebra substrate, committed ccc3efff0c),
   `Picard/CoherentWitness.lean` (the structure — fields `cover`, `le_pullbackInl/Inr`,
   `θ`, `witness`, `coherent`), `Picard/CoherentWitnessCochains.lean`,
   `Picard/UnitsGlobalPullback.lean` (the pullback calculus),
   `Algebra/LocalizationCocycle.lean` (the `IsCoverCocycle`/`cocycleUnit` template you
   are mirroring for the A-tower), `Descent/UnitDescent.lean` +
   `Descent/UnitDescentComposite.lean` (`IsDescentCocycle`, `picClass`, `tensorCollapse`,
   `collapse`, `picClass_collapse`).

## Design constraints and warnings (hard-won this session — binding)

- **Kernel discipline** (this killed the first ζ2·i attempt): NEVER `rw`/`simp only ... at`
  a hypothesis whose statement mentions concrete curve/Spec towers, and never let a
  reducible `abbrev` cover/cochain leak into statements. Pattern that works: opaque
  `def`s for any repeated cover/section datum + named `≤`-lemmas for their refinements +
  ONE abstract-schemes (or abstract-CommRing) lemma per rewrite-heavy step, instantiated
  by a single application. Pure `CommRing`/`Module`-level work (most of this brick) is
  far cheaper than scheme-level, but the same style applies at tensor towers.
- **Pi-ext over the right base** (recon §5-G3 note): `AlgHom.ext_of_isLocalization_pi`
  works over `B ⊗[A] B` (components are `Away` there via `isLocalization_away_tensor`),
  NOT over `A`. The transports in `TensorAwayPi.lean` were proved by pure-tensor
  computation instead — mirror whichever the goal shape wants.
- **The θ-to-ring bridge** (recon §4): `Γ(Spec R, D(g))` IS the `Away g` model
  (definitional); `unitsRestrict`/`unitsAppLE` values on basic opens are literally ring
  units. The gluing of point-indexed `θ'.θ`-values over a basic open uses
  `Scheme.exists_global_unit_of_compatible`-style 𝒪ˣ-gluing — but note the values are
  only compatible after trivialization-correction; design the correction BEFORE gluing.
- **ΓSpecIso bookkeeping** (recon §5-G5): the scheme-side base ring is
  `Γ((overSpec k B).left, ⊤) ≅ B`; decide ONCE how to cross it (the `SectionsAlgebra`
  helpers exist) and record the decision in the file docstring.
- Files ≤ 500 lines (split by content: e.g. `Picard/WitnessComponents.lean` for G5,
  `Algebra/PiAssembly.lean` or `Picard/PiAssembly.lean` for G4+G6); mathlib naming,
  full docstrings, `set_option autoImplicit false`; general statements PR-extractable
  where the content is pure algebra.
- Wire new files into `AlgebraicJacobian.lean` (a blueprint agent may edit
  `blueprint/**` concurrently — you own the Lean tree; re-read the aggregator before
  saving and apply only your lines).
- Do NOT touch `Challenge.lean`; no new axioms; no `sorry` in the final state.
- If the FULL contract does not fit one session, land the largest kernel-green,
  axiom-clean PREFIX (e.g. G5 components + their coherence, with G4/G6 stated in a
  design note), commit-ready, and report exactly where the frontier is. Never leave the
  tree red.

## Verification (FOREGROUND, non-negotiable)

1. Iterate with the lean-lsp MCP (the LSP and `lake` must not run concurrently during
   package materialization — irrelevant now that the tree is warm, but never run two
   builds at once).
2. When done: `lake build` from the project root, BLOCK until it finishes, paste the
   tail. Then `lean_verify` each keystone (axioms exactly
   `[propext, Classical.choice, Quot.sound]`). `grep -n -w sorry` on every touched file
   (grep exits 1 on zero matches — do not `&&`-chain it).
3. Do NOT run `git`; do NOT commit (the orchestrator audits and commits).

## Report format (final message)

Files created/changed (line counts) · declarations with one-line statements · the
interface decisions you made (component extraction shape, ΓSpecIso crossing, hypotheses
vs. dictionary-machinery reuse) · build tail verbatim · lean_verify outputs verbatim ·
frontier if the contract is partial · notes for the ζ3 spec-writer.
