# Brick spec — (C2) E1: the σ-normalized coherent comparison

*Written 2026-07-15 (Fable orchestrator). Consumer: one Fable implementation agent — this
is the (C2) campaign's heart, the mirror of ζ2·i's `exists_coherentCechWitness` (~750
lines), with the section replacing the upstairs trivialization as the source of coherence.
The BINDING route is `informal/c2-effectivity-assembly.md` decision D4; the terrain is
`informal/zeta-c2-effectivity-recon.md` §0.3 (the effectivity signature this feeds), §2a
(rigidification keystones), §2b (the reusable (C1) machinery, each with its role), §3-A2.*

## Mission

Inputs (the §0.3 setting): `A`, an étale cover `B := E.Carrier`, `σ : overSpec k A ⟶ C`,
`L : XB.CechPic` with `hrig : IsRigidified σ_B L` and the landed on-the-nose descent
equation `hdesc : CechPic.map u₁ L = CechPic.map u₂ L` on `Xq` (curve over
`Sq = Spec (B ⊗[A] B)`).

**Deliverable contract:** an opaque packaging (structure + existence theorem; exact
cochain-level formulation YOURS — see Stage 0) of a comparison datum `φ` realizing
`hdesc` at the cochain level, such that:
(N1) `φ` cobounds the two pullback cocycles of (a representative of) `L` on a stated
     cover of `Xq`;
(N2) `φ` is σ-NORMALIZED — its restriction along the section over `Sq` is trivial, in
     the precise sense Stage 0 fixes (the freedom in `φ` is a global unit of `Xq` by the
     H⁰ sheaf axiom; G2 `unitsAppTop_sectionOfPoint_bijective` identifies global units
     of the curve product with units of the affine base via the section, and `hrig`
     makes the σ-side stateable);
(N3) THE COHERENCE (the brick's point): the three coface pullbacks of `φ` to the curve
     over `Spec (B ⊗[A] B ⊗[A] B)` satisfy the cocycle identity on the nose —
     `φ₁₃ = φ₂₃ ∘ φ₁₂` in whatever composition sense (N1)'s packaging gives — proved by
     the lm:aut argument: the discrepancy `ε = φ₁₃⁻¹ φ₂₃ φ₁₂` is a global unit of
     `X_{B⊗3}` (H⁰ axiom again) whose σ-restriction is `1` by (N2), and G2 over `B⊗3`
     forces `ε = 1`.

All kernel-green, axiom-clean, no sorry. E2 (per-piece descent) will restrict this datum
along E0's pieces (`Picard/EffectivityPieces.lean` — read its final-report seam notes:
the identification is on-the-nose, `pieceRingEquiv_naturality` is the restriction
compat; the E0→E2 frontier is the `R = B⊗B` instance, NOT your problem unless free).

## Stage 0 — MANDATORY design gate (before any proving)

Write, in your report and as the docstring of the packaging structure, the PRECISE
statement of (N1)/(N2) in the tree's types: which cover carries `φ` (a basic refinement
subordinate to what — the landed `TrivializingFamily`/`BasicRefinement` calculus,
`PicAffineCover.lean`, is the (C1) vehicle), what "restriction along the section" means
for a cochain (the section-pullback cover of the affine `Sq` and the H⁰ collapse — mind
that `Sq` and `Xq` may be DISCONNECTED: étale covers produce products; the (C1) clopen
calculus `CechPicClopenSep/Glue.lean` and the finite-product `RelPicPi.lean` are landed
for exactly this, and `Xq` is NOT integral — nothing here may assume integrality), and
how the freedom-is-a-global-unit lemma is spelled (`global_unit_ext` / the ζ2·P H⁰
packaging, `AmitsurCochain.lean`). If Stage 0 reveals the D4 design needs amending
(e.g. normalization must happen classwise-per-clopen-piece rather than globally), the
amendment is YOURS to make — record it prominently; the worksheet writer flagged exactly
this freedom.

## The designed route (worksheet D4, expanded)

(a) EXTRACT: from `hdesc` via the mk-calculus (`CechPic.mk_eq_mk_iff` / `mk_eq_one_iff`
    / `class_eq_one_of_pic_eq_one` — the recon §2b catalogues the exact names) on a
    common basic refinement of the two pullback covers: a cochain `c` with
    `u₁^*λ / u₂^*λ = δc`.
(b) FREEDOM: two such cochains differ by a global unit of `Xq` (H⁰ sheaf axiom — the
    0-cocycle condition IS globality; no integrality).
(c) NORMALIZE: define the σ-defect of `c` (Stage 0's formulation), correct
    `c ↦ c · (pullback along the projection of the defect)⁻¹` using the G2 bijection
    (`unitsAppTop_sectionOfPoint_bijective`, `Rigidification.lean:333`) — `hrig` enters
    here (σ^*L = 1 makes the defect a unit of the base). The corrected `φ` has
    σ-restriction `1` BY CONSTRUCTION.
(d) COHERENCE: the Amitsur cofaces (`tensorFace₁₂/₁₃/₂₃`, THREE distinct composites,
    coincidence lemmas landed) transport `φ` to `X_{B⊗3}`; `ε := φ₁₃⁻¹ φ₂₃ φ₁₂` is a
    global unit (each face of `δc` telescopes — the (C1) telescope is in
    `CoherentWitnessCochains.lean`); its σ-restriction is `1` by (c) + the coface/section
    compatibilities (`overSpecMap_comp_section`, `sectionOfPoint_naturality` — landed);
    G2 at `B⊗3` kills it. State (N3) in the exact form E2/E3 consume (the descent-cocycle
    condition for the piece rings — check `Descent/UnitDescent.lean`'s `IsDescentCocycle`
    face conventions so the shapes align at zero cost).

**Staged fallbacks, in order:** (1) full (N1)–(N3); (2) (N1)+(N2) with (N3) precisely
frontiered; (3) (N1) + the Stage-0 design record (already valuable: it fixes E1's
statement for a continuation agent); (4) largest green prefix. Never a red tree.

## Constraints (binding — the ζ2·i kernel discipline, verbatim from the handoffs)

Opaque `def`s for every repeated cover/cochain/carrier + named ≤/refinement lemmas;
abstract lemmas (small types) instantiated once for anything rewrite-heavy; NEVER
`rw`/`simp only ... at` over hypotheses mentioning concrete curve/Spec towers; uniqueness
over the base where pi-ext lives (`B ⊗[A] B`, `B⊗3`), never over `A`; `(kernel)
deterministic timeout` ⇒ restructure; doc-comments after `set_option ... in`; the
`[proper + gi + gr]` triple via the `EtaleSeparatednessClose.lean:63` local-instance
pattern; files ≤ 500 lines (split freely: suggested `Picard/NormalizedComparison.lean` +
`Picard/ComparisonCoherence.lean`); `set_option autoImplicit false`; mathlib naming;
complete docstrings; search before proving. ONE build at a time; lean-lsp MCP to
iterate; FOREGROUND final verification (root `lake build` from the project dir,
`lean_verify` MCP on every keystone — axioms exactly `[propext, Classical.choice,
Quot.sound]`, sorry grep exits 1, no `&&`-chaining). Do NOT run git/commit; do NOT touch
`Challenge.lean` or `blueprint/**`; write scope = your new Picard/ files +
`AlgebraicJacobian.lean` import lines (re-read on staleness).

## Report format

Stage-0 record FIRST (the precise (N1)/(N2) statements + any D4 amendment) · stage
reached · files+lines · every public declaration with a one-line statement · deviations
with reasons · build tail verbatim · lean_verify outputs verbatim · frontier if staged ·
what E2's spec-writer must know (the exact datum shape they restrict, and whether the
`IsDescentCocycle` face conventions aligned or need a bridge).
