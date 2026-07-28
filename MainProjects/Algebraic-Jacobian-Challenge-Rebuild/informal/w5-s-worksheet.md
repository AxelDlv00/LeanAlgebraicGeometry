# W5 S-cluster worksheet — geometric reducedness (S1/R2), `Smooth` (S2), the frozen numeral (S3/R3)

*Produced 2026-07-28 by the Wave-5 AV lane (task `ajcr-w5-av`, run 0073), discharging the
WORKSHEET-FIRST obligation that `w5-worksheet.md` §1 D4 places on **S1** and **S3** (risks
R2 and R3 of `w5-recon.md` §5). S2 carries no worksheet requirement and is landed in the
same session. Every mathlib claim below was re-checked against the pinned checkout
(`.lake-packages/mathlib`, v4.31.0, `fabf563a7c95…`) this session; project claims against
the tree at HEAD after commit `45dd5aec6`. Nothing here is decided against a guessed shape:
the S-cluster consumes only `JacobianData` and the landed `Tangent/` kit, neither of which
waits on the DD freeze.*

---

## §0 Verdict in one line

**S2 is one line and is landed** (`smooth_of_grpObj`, mathlib
`AlgebraicGeometry/Group/Smooth.lean:64`, hypotheses `[LocallyOfFiniteType]` +
`[GrpObj (Over.mk f)]` + `[GeometricallyReduced f]`, the first two supplied by the datum).
**S1 is the whole S-cluster's cost** and route α1 survives probing — but with a correction
to the recon's description of it that changes which brick is hard (§2). **S3 is
[M]-shaped, not [L]**, and the R3 fear is now bounded from *both* ends: the descent half
has a full ingredient list (t4 worksheet §5) and the *uniformity* half — the part that
appendix left unprobed — turns out to have a clean route through mathlib's
`SmoothOfRelativeDimension` being a **local-at-source** property, so no
"locally constant relative dimension on an irreducible base" theorem is needed at all (§3).

---

## §1 S2 — `Smooth d.J.hom` (no worksheet gate; LANDED this session)

`smooth_of_grpObj (f) [LocallyOfFiniteType f] [GrpObj (Over.mk f)] [GeometricallyReduced f]`.
At `f := d.J.hom`: `LocallyOfFiniteType` is `d.locallyOfFiniteType`; the group structure is
`d.grpObj`, which must be **keyed at the `Over.mk` spelling** —
`letI : GrpObj (Over.mk d.J.hom) := d.grpObj` — pure defeq, and `JacobianData.lean`'s
η-defeq verdict already machine-checked exactly this as smoke test 2. `GeometricallyReduced`
is S1 and stays a hypothesis.

Worth recording *why* mathlib's proof needs geometric (not bare) reducedness: it base-changes
to `AlgebraicClosure K` and runs the homogeneity argument there
(`smooth_of_grpObj_of_isAlgClosed`, translating the smooth locus by `GrpObj.mulRight` until it
meets any prescribed closed point), then descends along `@Surjective ⊓ @Flat ⊓ @QuasiCompact`.
So the `k̄`-side reducedness is intrinsic to the route, not an artefact — which is also why S1
below is naturally stated geometrically.

## §2 S1 — `GeometricallyReduced d.J.hom` (WORKSHEET-FIRST, risk R2)

Route **α1** confirmed as the only live candidate; α2 (dimension count) remains unstateable
(mathlib has no scheme dimension theory — re-verified). But the recon's α1 sketch conflates
two steps of quite different cost, and naming that split is this section's job.

α1 as the recon states it: square-zero lifts of `k̄`-points of the *functor* all exist
because the obstruction is an `H²` of a two-term complex, identically zero ⟹ `𝒪_{J_k̄,0}`
formally smooth ⟹ regular ⟹ reduced at `0` ⟹ (spread by translations, X2) `IsReduced J_k̄`
⟹ geometrically reduced.

**The two-term-`H²`=0 half is the cheap half, and it is cheap for a structural reason.**
`pic0Functor` is defined through `picEt`, whose values are Čech classes on a **two**-chart
affine cover (`Tangent/TruncExpCech.lean`, brick T2, landed). A two-term Čech complex has no
degree-2 term *at all*: the obstruction group is not "computed to be zero", it is absent by
construction. This is the curve-lite replacement the recon wanted for Kleiman `prp:H2`, and
it is why the standing instruction never to port EGA III 7.7.5/7.7.10 Exchange (descope
boundary R6, `w5-recon.md` §1.4) costs nothing here.

**The expensive half is the ring-level bridge**, and the recon flags it correctly but
understates it: *"functor-lifts ⇒ local ring formally smooth ⇒ regular/reduced"*. Probing the
three links:

| link | status in pinned mathlib |
|---|---|
| square-zero lifting criterion for `FormallySmooth` | **present** — `Algebra.FormallySmooth.iff_comp_surjective` / `comp_surjective` (`RingTheory/Smooth/Basic.lean:83`) |
| formally smooth local `k̄`-algebra ⇒ regular | **PARTIAL** — the general statement is Cohen-structure-flavoured; what mathlib has is `RegularLocalRing` API (`RingTheory/RegularLocalRing/Defs.lean`) and smooth⇒regular for *scheme* morphisms, not the local-algebra implication under a bare `FormallySmooth` |
| regular local ⇒ reduced | **present** — regular local rings are domains, hence reduced |
| `IsReduced J_k̄` ⇒ `GeometricallyReduced` | **present in-project** — `Curve/GeometricallyReduced.lean` (mathlib-general; flagged in I-0495 as an upstreaming candidate) |

So R2's real content is link 2, and it is a **local-algebra** gap, not a geometric one.

**RECOMMENDED REFRAME, and the reason to write this worksheet before the Lean.** Do not go
through `FormallySmooth` on the local ring at all. Mathlib's own group-scheme route (§1)
only ever needs `IsReduced` of the `k̄`-fibre, and `IsReduced` of a scheme is a *stalkwise*
condition. The functor-lifting input gives, at the identity, that every square-zero
thickening of a `k̄`-point lifts — which is exactly the statement that the local ring has no
nonzero nilpotent *in the direction of the cotangent space*, and the two-term complex makes
that direction-wise statement uniform. Concretely the brick to state is

> **S1-a**: for the identity point `0` of `J_k̄`, the stalk `𝒪_{J_k̄,0}` is reduced,

proved from the ε-kernel computation (T3/T4 at `K := k̄`, which route (ii) of the t4 worksheet
supplies *uniformly in `K`* — this is exactly the payoff the t4 worksheet promised in its
"why (ii) over (i)" item 3), and then

> **S1-b**: `IsReduced J_k̄` from S1-a by translation homogeneity (X2, landed:
> `AbelianVariety/Translation.lean`), and `GeometricallyReduced d.J.hom` from S1-b via
> `Curve/GeometricallyReduced.lean`.

**Gate**: S1-a genuinely needs T3/T4. It cannot be started before them, and pretending
otherwise is how this lane burned sessions before. S1-b is startable now and is [S].

**Risk left after this reframe (record as R2'):** whether "reduced stalk at the identity" is
derivable from the ε-kernel count *alone* or needs the full deformation functor. If the
latter, the fallback is to state S1 as a hypothesis of S2/S3 (both are already written that
way — see §3) and let the AV package be conditional on it, which keeps every *other* Wave-5
item unblocked. That fallback is cheap precisely because S2 and S3 take
`GeometricallyReduced` as an instance argument rather than proving it.

## §3 S3 — `SmoothOfRelativeDimension (genus C) d.J.hom` (WORKSHEET-FIRST, risk R3)

The t4 worksheet §5 answered the *descent* half of R3 (a buildable [M] brick supplying
`RingHom.CodescendsAlong (Locally (IsStandardSmoothOfRelativeDimension n)) FaithfullyFlat`,
absent from mathlib) and explicitly left the *uniformity* half unprobed: "rel-dim locally
constant on an irreducible base". Probing it now.

**Finding: the uniformity half does not need a locally-constant-dimension theorem.** Unfold
the mathlib class (`Morphisms/Smooth.lean:135`):

```
class SmoothOfRelativeDimension n (f : X ⟶ Y) : Prop where
  exists_isStandardSmoothOfRelativeDimension :
    ∀ (x : X), ∃ U V e, IsStandardSmoothOfRelativeDimension n (f.appLE U V e).hom
```

It is a **pointwise, local-at-source** condition: for *each* `x` separately, *some* chart
around `x` of relative dimension `n`. There is no coherence requirement between charts and
no connectedness hypothesis. So the assembly is:

1. `Smooth d.J.hom` (S2) gives, at every `x`, *a* standard-smooth chart
   (`Smooth.iff_forall_exists_isStandardSmooth`).
2. Its relative dimension at `x` is pinned by the cotangent rank there —
   `IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` with the rank lemma
   `RingTheory/Smooth/StandardSmoothCotangent.lean:319/:313`.
3. **Translation transports the count from the identity to every `x`** — X2, landed
   (`AbelianVariety/Translation.lean`, "transport of point-local properties along `τ_g`").
   This replaces "dimension is locally constant" with "the group acts transitively enough",
   which is the honest reason it is true for a group scheme and needs no topology.
4. At the identity the count is `genus C` — T5, landed as
   `finrank_cotangentSpaceDual_eq_genus` (conditional on the T3/T4 numeral).

**Consequence: S3 does NOT need the t4-§5 codescent brick.** That brick was the price of
*coming home from `k̄`*. Route (ii) of the t4 worksheet hands the count at `k` directly
(worksheet §2 item 3), and step 3 above is a `k`-side transport, so the chain never leaves
`k` and `Spec k̄ → Spec k` descent never enters. **R3 is downgraded: [M], no mathlib-absent
brick.** The §5 brick stays documented as the fallback if step 3's translation transport
turns out to need the `k̄`-points (which it should not — `X2` is stated over the base).

One caveat, recorded so no prover meets it mid-brick: step 3 transports a property *at a
point*, and the mathlib class quantifies over points of the source `X` — for a group scheme
over a field with a rational identity, translations by `k`-points may not reach every
*scheme* point of `d.J` (only the rational ones). If that bites, the honest fix is to run
steps 1–3 after base change to `k̄` (where closed points are rational and mathlib's own
`smooth_of_grpObj_of_isAlgClosed` does the same thing for the same reason) and *then* pay the
§5 codescent brick. So the §5 brick is the **contingency for exactly this caveat**, not for
the count itself. Probe this before writing S3's Lean.

## §4 Dependency summary (what is startable when)

| brick | gate | size | startable at HEAD? |
|---|---|---|---|
| S2 `Smooth d.J.hom` | S1 as instance arg | XS | **yes — landed this session** |
| S1-b `IsReduced J_k̄ ⇒ GeometricallyReduced` | X2 (landed) | S | yes |
| S1-a reduced stalk at identity | T3/T4 | M/L | **no** |
| S3 assembly | S2 + T5 + X2 | M | shape frozen here; numeral waits on T3/T4 |

The honest bottom line for the lane: **after T1/T5, every remaining Wave-5 item funnels
through T3/T4.** S1-a, T5's numeral and S3's count are three consumers of one computation.
That is a good position — it means the next session has exactly one target — but it also
means no amount of S-cluster work substitutes for it.
