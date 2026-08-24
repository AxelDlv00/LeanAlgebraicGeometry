# (C2) effectivity — assembly worksheet

*Written 2026-07-14 (Fable orchestrator), from `informal/zeta-c2-effectivity-recon.md`
(the recon half — inventory, API map, gap list, Kleiman anchors; cited below as RECON).
This document is the ROUTE DESIGN: the decisions the recon left open are made here and
are binding for the campaign's specs. Model: `informal/c1-etale-separatedness-assembly.md`.*

## Target

RECON §0.1: `PicEtAff.unit_surjective_of_section` (+ `unitEquiv_of_section`), section as a
theorem hypothesis. Everything reduces (RECON §0.2, a one-screen dual of the landed (C1)
unfold) to ONE effectivity brick, RECON §0.3:

> a rigidified class `L` on the curve over the étale cover `Spec B`, whose two pullbacks
> to the curve over `Spec (B ⊗[A] B)` are equal on the nose (`hdesc`, handed over by the
> landed `IsRigidified.cechPicMap_doubleInl_eq_doubleInr`), descends along the cover
> inclusion `cg` on the curve product: `∃ M : XA.CechPic, cg^* M = L`.

Signature carries BOTH `hrig` and `hdesc` (RECON risk 4 — defensive; their exact necessity
is a design variable the A2 spec may tighten, recording any weakening).

## Decisions (made now, binding)

**D1 — Route A (per-piece), not Route B.** RECON §3's analysis is endorsed: there is no
global unit to seed a (C1)-style `w` because `L` is nontrivial on the cover; any "global"
object degenerates to per-piece data. Route A is the correction record's route and has the
landed mirrors.

**D2 — construct `M` explicitly, with TRACKED DESCENT DATA (recon's option (i)), never a
class-only argument.** Reason (this is the mathematical heart of why A4 closes): for a
faithfully flat ring map `R → S`, `ker(Pic R → Pic S)` is Amitsur `H¹(S/R, 𝔾ₘ)` — nonzero
in general — so per-piece descended CLASSES `M_V` that merely *pull back to* `L|` need not
agree on overlaps. What glues is not the classes but the descents OF ONE FIXED GLOBAL
DATUM: A2 produces a single σ-normalized comparison cochain on `Xq`, restricted to every
piece; descent of a *fixed* datum is unique up to *canonical* (datum-compatible) iso, and
canonicity kills the triple-overlap H² obstruction that blocks gluing abstract classes.
Every A3/A4 spec must preserve this: the per-piece output is (class + tracked cocycle +
base-change compatibility), never a bare `Pic` element.

**D3 — A4 mechanism: refinement-splice over an affine basis, not direct cover-gluing.**
`M` is NOT trivial on the pieces `V`, so the cover `{V}` cannot carry `M`'s cocycle
directly. Mechanism: within each piece, present the descended class by a trivializing
basic refinement (landed `TrivializingFamily` / `BasicRefinement` calculus, the ζ3
machinery — it already runs on curve-product schemes); on overlaps `W = V ⊓ V'` (affine —
`XA` is separated: `C` proper over `k`), the two descent cocycles restrict from the SAME
global normalized `φ`, hence are EQUAL on the nose (arrange the restriction maps
opaquely), so the descended classes agree via the landed descent base-change bricks
(`Descent/UnitDescentBaseChange.lean` pattern, `Pic.mapAlgebra`-compatibility of
`picClass`); splice the refined trivializations into one Čech cocycle over the refined
cover of `XA`, cocycle condition on triples from datum-canonicity. `cg^* M = L` at the end
by `mk`-calculus over a common refinement (the kernel lemma's final-assembly pattern,
`CechKernelLemma.lean:291-346`, run in the constructive direction).

**D4 — A2's σ-normalization design (the Fable-grade heart, mirror of
`exists_coherentCechWitness`).** Fix the mathematical shape now so the spec doesn't
rediscover it:
(a) extract from `hdesc` a cochain comparison on a basic refinement of `Xq` (mk-calculus);
(b) package the freedom in that choice as a GLOBAL UNIT of `Xq` (two cochains cobounding
the same ratio differ by a global unit — the ζ2·P `global_unit_ext`/H⁰ packaging);
(c) σ-normalize: global units of the curve product over an affine test biject with units
of the base ring via the section (G2 `unitsAppTop_sectionOfPoint_bijective`, which
retracts the projection-pullback bijection `universalSections`); rescale the comparison by
the projection-pullback of the inverse of its own section-pullback, making its
σ-restriction `1` — this uses `hrig` (σ^*L = 1) to even *state* the section-pullback of
the comparison as a unit of the base;
(d) triple-product coherence (lm:aut): the coboundary automorphism `ε = φ₁₃⁻¹ φ₂₃ φ₁₂` on
`X_{B⊗B⊗B}` is a global unit whose σ-pullback is `1` by (c); G2 over `B⊗B⊗B` forces
`ε = 1`. Amitsur cofaces and their coincidences are landed (`AmitsurCochain.lean`,
`tensorFace₁₂/₁₃/₂₃` — only three distinct composites).
The novelty vs (C1) is exactly (c): the section replaces the upstairs trivialization as
the source of coherence. Everything else mirrors landed code.

**D5 — sequencing vs the other lanes.** The campaign starts AFTER the degree/Pic⁰ first
bricks (handoff order; degree is cheaper, Wave-4-facing, and (C2)-independent — RECON
§1.3/degree-recon both verify the disjoint cores). R0 and the blueprint chapter can be
drafted early against the §0.3 signature (RECON §3), but no prover launches on A2 before
its own spec.

## Sub-brick decomposition (specs to be written one per brick, house format)

- **E0 = A1 [GEO, Opus]: cg-saturated affine pieces.** Affine basis of `XA` closed under
  the needed intersections; `cg⁻¹V` affine (`cg` is affine); the ring identification
  `Γ(cg⁻¹V) ≅ Γ(V) ⊗[A] B` with faithful flatness over `Γ(V)` (generalize the landed
  `sectionsTopAlgEquiv` ⊤-case; RECON risk 3 — if the identification fights, fall back to
  `IsLocalization`-style characterization on a basic-open subbasis). Deliverable includes
  the restriction-compatibility lemmas (opaque defs for the piece rings + named ≤-lemmas)
  that D2/D3 need downstream. Verify early — this de-risks the campaign's geometry.
- **E1 = A2 [MIX, FABLE]: the σ-normalized coherent comparison.** Per D4. Its spec gets
  the full (C1) ζ2·i treatment: exact deliverable signatures (the normalized cochain as an
  opaque structure with its two defining properties: coboundary equation on `Xq`,
  σ-restriction `1`; plus the triple coherence), staged fallbacks, kernel discipline.
  Expect the campaign's largest brick (mirror is ~750 lines); split further at spec time
  if needed ((a)/(b) extraction vs (c)/(d) normalization).
- **E2 = A3 [LA, Opus]: per-piece descent datum + brick 4.** From E1's cochain restricted
  along E0's pieces: `Module.IsDescentCocycle` over `Γ(V)` along `Γ(V) → Γ(V) ⊗[A] B`,
  `picClass` descent, `cechPicEquivPic` transport to `V.CechPic` — WITH the D2 tracking
  (cocycle + base-change compatibility as part of the deliverable, mirror `assemblyUnit` +
  `mapAlgebra_picClass_assemblyUnit`).
- **E3 = A4 [GEO/MIX, FABLE]: refinement-splice reassembly.** Per D3. Three stages inside
  one spec: (E3a) restriction canonicity — equal descent data on overlaps ⇒ equal
  descended classes, via the landed descent-base-change bricks; (E3b) the splice —
  trivializing basic refinements within pieces, transition units, triple cocycle from
  canonicity; (E3c) `cg^* M = L` by mk-calculus. If (E3b) balloons: acceptable staged
  landing is the splice for a FINITE basic cover (quasi-compactness of `XA` gives one —
  the kernel lemma already extracts finite basic subcovers), which suffices.
- **E4 = R0 [LA, Opus]: the surjectivity close.** RECON §0.2 verbatim; write LAST against
  the landed effectivity name. Plus `unitEquiv_of_section`. Blueprint chapter concurrent.

Dependency: E0 → E1 → E2 → E3 → (effectivity §0.3) → E4. E1 does not need E0 (it lives on
`Xq`/`X_{B⊗3}`, no pieces) — E0 and E1 can run as consecutive provers in either order, but
E0-first is preferred (cheapest de-risk first, and E2's spec wants both in hand).

## Kernel discipline (inherited, binding — the (C1) lessons)

Opaque `def`s for piece rings, covers, cochains; named restriction/≤-lemmas; NO
`rw`/`simp only ... at` over hypotheses mentioning concrete curve/Spec towers; abstract
lemmas (small types) instantiated once; uniqueness over the base where pi-ext lives
(`B ⊗[A] B`, `Γ(V) ⊗ ...`), never over `A`; `(kernel) deterministic timeout` ⇒
restructure; the `[proper + gi + gr]` triple threaded via the (C1) close's
`attribute [local instance]` pattern (`EtaleSeparatednessClose.lean:63`); files ≤ 500
lines; one prover at a time; lean_verify (MCP) for axiom checks.

## Acceptance criteria

Each brick: kernel-green (target + root `lake build`), axiom-clean
`[propext, Classical.choice, Quot.sound]`, no sorry, committed with math-first message,
blueprinted (the `(C2)/Effectivity` sections with `\source{kleiman-picard}` anchors on
th:cmp Part 2 / df:rgd / lm:idn / lm:aut — read-before-cite). Campaign close =
`unit_surjective_of_section` + `unitEquiv_of_section` verified, roadmap `AJCR.picard.c2`
→ done, handoff updated.
