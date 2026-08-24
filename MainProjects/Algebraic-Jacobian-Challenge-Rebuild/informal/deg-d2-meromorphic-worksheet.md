# G-D2 (meromorphic bridge) — design worksheet

*Written 2026-07-14 (Fable orchestrator). The degree lane's gate and its flagged
ballooning risk (`informal/degree-pic0-recon.md` §3 G-D2, §5 risk 1). Route design per
the (C2) lesson: decisions first, prover only from a spec derived from this worksheet.
Inputs: the recon's §2 API map, design `wave3-picard-design.md` §2.6(c)/§6.1, the landed
deg-D1 (`Picard/PointDivisor.lean`), the landed χ-ledger (`RiemannRoch/Chi*.lean`).*

## Target (what the interface actually consumes — DESCOPED from the recon's G-D2)

The recon lists two sub-claims: (i) `divisorSheaf K D` *is* the invertible sheaf of class
`divisorClass K D`; (ii) surjectivity — every `CechPic` class of the integral curve
bundle is a `divisorClass`. **Decision T1: the critical path needs (ii) + an extraction
lemma, and does NOT need (i).** What G-D3 (`classDeg`, E-i..E-iii) consumes is exactly:

- **(S) surjectivity**: `∀ L : X.CechPic, ∃ D : X.CurveDivisor, divisorClass K D = L`;
- **(X) extraction**: `divisorClass K D = divisorClass K D' → ∃ f : X.functionFieldˣ,
  D - D' = divOf f` — because then `classDeg L := deg K D` (any (S)-witness) is
  well-defined via the landed `deg_divOf` + `deg_add`, and
  `chi (divisorSheaf K D)` is witness-independent via the landed `mulEquivDivisorSheaf`
  + `chi_congr`. Sub-claim (i) is blueprint-nice but consumed nowhere; park it
  (optional follow-up node, not a brick).

## The load-bearing structural decision

**D1 — every cochain comparison happens inside the function field.** On an integral
scheme, every nonempty open contains the generic point η and sections inject into
`K(X)` by germ-at-η (the landed `germ_generic_eq_algebraMap_germ` /
`germGenericLinear_mem` machinery from `DivisorSheafZero.lean`, plus `Scheme.IsIntegral`
section injectivity). So cocycle values, cobounding units, and local equations all
embed in `K(X)ˣ`, where "gluing" is literal equality of field elements — NO sheaf
gluing, NO clopen calculus, NO refinement-vs-refinement cocycle comparison beyond what
the landed `picClass_mul`/`picClass_rescale`/`restrict` already provide. This is why the
bridge is bounded where (C2)'s effectivity is a campaign: there the class lives on a
NON-integral-relative product over a general test ring and must be descended; here
integrality of the single curve collapses everything into `K(X)`. (Design §6.1's remark
— geometric integrality is exactly what makes this uniform in the base field — is this
point.)

## Sub-bricks (dependency order; one prover each, Opus unless noted)

- **W1 [GEO, bounded] — the meromorphic presentation of a cocycle.** For a class `L`
  presented by a cocycle `g` on a pointed cover `𝒰`: fix the base index trick (design
  §2.6(c)) — for a chosen base point index `x₀`, the elements `f_x := (g x x₀)` viewed
  in `K(X)ˣ` (germ-at-η of a unit section is a unit of the function field — needs the
  small lemma "unit section ↦ unit germ", check `OpenImmersionUnits`/`DivisorSheafZero`
  for the landed form) satisfy, in `K(X)ˣ`: `f_x / f_y = germ (g x y)` on the nose (the
  cocycle identity pushed to η — one triple-overlap instance, all opens meet).
  Deliverable: `MeromorphicPresentation` structure (cover + `f : ι → K(X)ˣ` + the ratio
  property) + `exists_meromorphicPresentation (L)`. Choice discipline: `x₀` is data
  inside the construction; the class-level statements below are choice-independent by
  construction (they only cite the ratio property).
- **W2 [GEO/MIX, bounded] — the divisor of a meromorphic presentation.**
  `D_x := ordZ x (f_{c(x)})` for a piece `c(x) ∋ x`: independence of the piece choice
  (on the overlap the ratio is a unit SECTION at x, and unit-at-x sections have
  `ordZ = 0` — landed `ord_eq_one_of_mem_basicOpen`-adjacent; check exact form),
  finite support (each `f_x` has finite `divOf`-support via the landed
  `ordZ_support_finite`, plus a finite subcover from `[QuasiCompact]` — the landed
  finite-basic-subcover machinery), yielding `presentationDivisor : … → X.CurveDivisor`.
- **W3 [MIX, the heart — FABLE spec, possibly Fable prover] — `divisorClass
  (presentationDivisor P) = L`.** Route: both sides restricted to a common refinement;
  on each refined piece, the pointDivisor-product side trivializes by construction
  against the `f`-equations; the needed local statement is **ord-matching ⇒ unit
  ratio**: two elements of `K(X)ˣ` with equal `ordZ` at every closed point of an open
  `V` differ by a unit SECTION on `V` (from the landed pole-bound stalk lemma
  `exists_stalk_of_ord_le_one` applied to both quotients — this is `𝒪(0)(V) ∩ inverse
  ∈ 𝒪(0)(V)` = unit; spell via `divisorSections` at `D = 0` + `divisorSheafZeroIso`).
  Then the two cocycles differ by the coboundary of those units — `picClass_rescale` +
  `restrict` close it. RISK NOTE: this is where the (C2)-style balloon would live if it
  lives anywhere; the spec must stage it (the local ord-matching lemma is its own
  deliverable, valuable even if the cocycle assembly stalls).
- **W4 [MIX, bounded] — the extraction lemma (X).** Given `divisorClass D =
  divisorClass D'`: apply W1–W3 machinery in reverse — the product cocycles differ by a
  coboundary `c`; the elements `(equation of D−D' on piece x)·c_x⁻¹ ∈ K(X)ˣ` agree on
  overlaps AS FIELD ELEMENTS (D1: injectivity into `K(X)`), hence are ONE element `f`;
  `divOf f = D − D'` by W2-type ord bookkeeping. Deliverable exactly (X).
- **W5 [LA, one screen] — `classDeg` + E-i/E-ii/E-iii wiring = the recon's G-D3**,
  launched only after W1–W4 (its totality consumes (S), its well-definedness (X), its
  values the landed χ-ledger).

## AMENDMENT 2026-07-15 — W6 added (T1 partially reversed)

The Wave-4 datum design pass (`informal/w4-datum-design.md`) RESURRECTS the parked
sub-claim (i): its fibrewise large-twist vanishing route needs the sheaf-level
identification "`divisorSheaf K D` is an invertible sheaf of class `divisorClass K D`"
(or the precise weaker comparison its worksheet will pin). Schedule it as **W6** after
W5 — no longer optional; its spec-writer should read w4-datum-design §4 for the exact
consumer shape before choosing the statement.

## What this worksheet deliberately does NOT decide

Whether W3's prover is Opus-with-Fable-spec or Fable end-to-end — decide from W1/W2's
experience report (if the `K(X)ˣ`-embedding lemmas came out clean, Opus can carry W3
from a detailed spec). The exact `MeromorphicPresentation` packaging (structure vs
bundled Exists) — prover's choice within the kernel discipline (opaque def + named
lemmas).

## Discipline (inherited, binding)

All the standing kernel/elaboration rules; plus, specific to this campaign: never
compare cochains as sections when the comparison can be stated in `K(X)ˣ` (D1 — if a
proof is doing sheaf-level gluing, it has left the designed route; stop and restate);
`[QuasiCompact]` appears exactly at W2's finite-support step; K explicit-first per the
RiemannRoch convention; use `CurveDivisor.single`/`toFinsupp` per the landed calculus
(never raw `Finsupp.single` in +/−/• positions).

## Acceptance

Per brick: kernel-green (target + root), axiom-clean, no sorry, committed, blueprinted
(these ARE Hartshorne II.6.15-adjacent — check references/manifest for an honest read
source before anchoring; the classical statement is for schemes, ours is the cocycle
model — cite only on a real match). Campaign close = (S) + (X) landed → G-D3 unblocked
→ the E-i..E-iii brick → roadmap `AJCR.picard.degree` advances.
