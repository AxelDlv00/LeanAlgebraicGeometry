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
to the recon's description of it that changes which brick is hard (§2), and with a *second*
correction, to this worksheet's own first draft, that adds a mathlib-absent brick nobody had
counted: "reduced after base change to `k̄` ⟹ geometrically reduced" is **not** available,
in either project or mathlib, and the missing content is exactly the transcendental-extension
case (§2.1 — read it, it retracts a claim made in §2). Recommendation: **keep S1 a
hypothesis**; the AV package assembles conditionally on it today.
**S3 is [M]-shaped, not [L]**, and the R3 fear is now bounded from *both* ends: the descent
half has a full ingredient list (t4 worksheet §5) and the *uniformity* half — the part that
appendix left unprobed — turns out to have a clean route through mathlib's
`SmoothOfRelativeDimension` being a **local-at-source** property, so no
"locally constant relative dimension on an irreducible base" theorem is needed at all (§3),
and the t4-§5 codescent brick is contingency rather than a requirement.

**The single sentence that matters for planning:** after T1/T5 (landed), the T5 numeral,
S1-a and the S3 count are three consumers of **one** computation, T3/T4. Nothing in the
S-cluster substitutes for it.

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
| `IsReduced J_k̄` ⇒ `GeometricallyReduced` | **ABSENT — see the retraction in §2.1.** I first read `Curve/GeometricallyReduced.lean` as supplying this; it supplies the converse (`Smooth ⇒ GeometricallyReduced`), which would be circular here |

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
> `AbelianVariety/Translation.lean`, which already exports the exact transport
> `isReduced_stalk_pointTranslationIso_iff`), and then `GeometricallyReduced d.J.hom`.

**Gate**: S1-a genuinely needs T3/T4. It cannot be started before them, and pretending
otherwise is how this lane burned sessions before.

### 2.1 CORRECTION to my own §2 above: S1-b is NOT [S], and the reason is a mathlib gap

I wrote "S1-b is startable now and is [S]" one paragraph ago on the strength of
`Curve/GeometricallyReduced.lean` being available. **That was wrong and I am retracting it
in the same document** (the project's retraction discipline, I-0494). What that file
actually proves is the implication in the *other* direction —
`Smooth f ⟹ GeometricallyReduced f` (`:130`), plus
`SmoothOfRelativeDimension n f ⟹ GeometricallyReduced f` (`:147`). Using it for S1 would be
circular: S2 derives `Smooth` *from* `GeometricallyReduced`.

What S1-b actually needs is the descent step

> `IsReduced (J ×_k k̄)` ⟹ `GeometricallyReduced d.J.hom`,

i.e. "reduced after base change to the algebraic closure ⟹ reduced after base change to
*every* field extension". Checked this session, and this is the finding:

* the scheme-level class is `GeometricallyReduced f ↔ geometrically IsReduced f`
  (`AlgebraicGeometry/Geometrically/Reduced.lean:44`), and `geometrically P f` quantifies
  over **all** fields `K` with a map to the base (`Geometrically/Basic.lean:46`). The file
  offers base-change stability, fibre reformulations, and
  `isReduced_of_flat_of_isLocallyNoetherian` — but **no reduction of the quantifier to the
  algebraically closed case**.
* the algebra-level analogue *does* have exactly that reduction:
  `Algebra.IsGeometricallyReduced` with
  `isGeometricallyReduced_field_iff : IsGeometricallyReduced k A ↔ IsReduced (AlgebraicClosure k ⊗[k] A)`
  (`RingTheory/Nilpotent/GeometricallyReduced.lean:62`), plus the useful instance at `:71`
  giving `IsReduced (K ⊗[k] A)` for every algebraic `K/k`.
* **but the two are not connected**: `grep -rl IsGeometricallyReduced Mathlib/AlgebraicGeometry/`
  returns *nothing*. There is no `HasAffineProperty`/`HasRingHomProperty` instance tying the
  scheme class `GeometricallyReduced` to the algebra class `Algebra.IsGeometricallyReduced`.

So S1-b decomposes into a **new mathlib-facing brick**:

> **S1-b0** (`AbelianVariety/GeomReducedAlgClosed.lean`): `GeometricallyReduced f` for
> `f : X ⟶ Spec (.of k)` follows from `IsReduced (X ×_k k̄)`. Route: affine-locally, via
> `geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms` (`Geometrically/Basic.lean:136`)
> to reduce the quantifier to pullbacks, then an algebra bridge on section rings.

**Sizing it honestly, by machine probe rather than by eye** (three `lean_run_code` probes
this session, results recorded because they are what a later session would otherwise redo):

1. `IsGeometricallyReduced k A` + `[Algebra.IsAlgebraic k K]` ⟹ `IsReduced (K ⊗[k] A)` —
   **fires by `infer_instance`** (mathlib's instance at
   `RingTheory/Nilpotent/GeometricallyReduced.lean:71`).
2. the same **without** `IsAlgebraic` — **fails**: no instance, and `exact?` finds nothing.
3. the crux the textbook proof reduces to — `k` algebraically closed, `A` reduced, `K/k` an
   arbitrary field extension ⟹ `IsReduced (K ⊗[k] A)` — **also absent**; `exact?` finds
   nothing.

So the gap is **exactly the transcendental case**. Mathlib's `IsGeometricallyReduced` is
defined by base change to `AlgebraicClosure` of residue fields and its transport lemmas stop
at algebraic extensions; the passage to a general extension is the standard
"reduced ⊗ field stays reduced over an algebraically closed base" argument (Stacks 030U
neighbourhood), which is genuine commutative algebra — f.g. reduction via
`IsReduced.tensorProduct_of_flat_of_forall_fg` (`RingTheory/Flat/Basic.lean:642`, present)
plus a separating-transcendence-basis or Noether-normalisation step that is **not** present.

**Size correction: S1-b0 is [M/L], not [S/M].** I revise my own estimate of two paragraphs
ago. It is still a clean, self-contained, genuinely upstreamable statement with no
dependency on anything else in Wave 5 — but it is not the afternoon's work the first reading
suggested, and a session that starts it expecting [S] will overrun.

**Recommendation, and the reason this worksheet exists:** do **not** start S1-b0 as part of
the S-cluster. Two better options, in order:

* **(a) Keep S1 a hypothesis.** S2 and S3 already take `GeometricallyReduced` as an instance
  argument, so the entire AV package can be assembled *conditionally* on S1 with no further
  work. That is strictly more valuable per session than S1-b0, because it unblocks S3 and
  the AV assembly while leaving one clearly-labelled input open.
* **(b) A `smooth_of_grpObj` variant taking the `k̄`-fibre directly.** Mathlib's
  `smooth_of_grpObj` consumes `GeometricallyReduced`, but its *proof* only ever uses the
  `AlgebraicClosure k` fibre (it base-changes there immediately and descends along
  `@Surjective ⊓ @Flat ⊓ @QuasiCompact`). So a variant hypothesised on
  `IsReduced (X ×_k k̄)` looked like it would bypass S1-b0 for an [S] price.

  **PROBED THIS SESSION, AND IT DOES NOT.** Two further probes: `IsReduced G` +
  `[IsAlgClosed K]` ⟹ `Smooth f` for a group scheme — `exact?` finds nothing (the useful
  half, `smooth_of_grpObj_of_isAlgClosed`, is `private` in mathlib and therefore not
  reachable from a downstream project); and, more fundamentally, `IsReduced G` +
  `[IsAlgClosed K]` ⟹ `GeometricallyReduced f` — **also absent**. That second failure is the
  informative one: even over an algebraically closed base, mathlib will not upgrade
  `IsReduced` to `GeometricallyReduced`, because doing so *is* the transcendental-extension
  statement of probe 3. Option (b) does not dodge S1-b0's content; it relocates it.

  Salvage: the `private` marker is the only obstacle to the *first* half. An upstream PR
  making `smooth_of_grpObj_of_isAlgClosed` public (or adding the `IsReduced`-hypothesised
  variant next to it) would be a genuinely [XS] mathlib contribution that leaves AJCR needing
  only reducedness over `k̄`. **That is the recommended external action**, and it is worth an
  inbox item `--to human` rather than a local workaround.

Sizes update: **S1-b = S1-b0 [M/L, deprioritised — prefer (a), with (b)'s upstream PR as the
cheap external unblock] + translation spread [S]**, and only S1-a is T3/T4-gated.

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

## §3.5 A warning for whoever takes P1 (not the S-cluster, but it belongs in a Wave-5 doc)

Recorded 2026-07-28 from `ajcr-charts`' audit on inbox I-0494, because the lane it affects
does not exist yet and the finding would otherwise be discoverable only from a thread.

**The witness predicates do not assert effectivity or degree.** All three of
`BasicOpenCocycleDatum.HasWitnessH1Vanishing` (`Picard/Pic0ChartLocusFibreField.lean:115`),
`subsingleton_h1_tensor_iff_exists_witness` (`Picard/DivisorFamilyH1Locus.lean:182`) and
`IsSplitWitness` (`Picard/Pic0ChartLocus.lean`) ask only for *some* `CurveDivisor W` in the
class with `Subsingleton (H¹ …)`. None asks for `0 ≤ W`; none asks for `deg W = g` — even
though the worksheets throughout say "effective degree-`g` witness with `h¹ = 0`".

This is **correct and must not be "fixed"**: the dictionary is an iff against the engine's
condition `Subsingleton (H¹(pair D) ⊗ L)`, which cannot see effectivity or degree, and that
iff is what carries openness to a class-indexed locus. Degree is supplied externally from the
chart-index constraint via `degAt_chartTwist`; effectivity is supplied *nowhere* by these
predicates.

**Why this is a Wave-5 concern.** P1 — the `AbelSourceData` discharge — builds the Abel
morphism from the universal degree-`d` class (`rep.homEquiv.symm` plus a `fiberTwist` shift)
and gets field-point surjectivity from `riemann_inequality_curve` (`h⁰ ≥ deg + 1 − g ≥ 1`).
That last step **is** an effectivity statement, so the P1 prover is exactly the consumer who
will reach for "effective degree-`g` witness" and not get effectivity from the witness
predicate. The right address for the stronger reading is
`eq_of_picClass_eq_of_h0_one`, which does take `0 ≤ D`.

Wave 5 as landed is **not** exposed: `AbelSourceData`'s five fields (`D`, `isProper`,
`geometricallyIrreducible`, `abel`, `surjective`) mention no witness, degree or effectivity,
and grep confirms no file under `Tangent/` or `AbelianVariety/` touches the witness
predicates. Nothing landed needs revisiting — this is a note for the future P1 session.

## §4 Dependency summary (what is startable when)

| brick | gate | size | startable at HEAD? |
|---|---|---|---|
| S2 `Smooth d.J.hom` | S1 as instance arg | XS | **yes — landed this session** |
| S1-b0 `IsReduced (X ×_k k̄) ⇒ GeometricallyReduced` | none (mathlib-facing) | S/M | **yes** — see §2.1; upstreamable |
| S1-b translation spread | S1-a + X2 (landed) | S | after S1-a |
| S1-a reduced stalk at identity | T3/T4 | M/L | **no** |
| S3 assembly | S2 + T5 + X2 | M | shape frozen here; numeral waits on T3/T4 |

The honest bottom line for the lane: **after T1/T5, every remaining Wave-5 item funnels
through T3/T4.** S1-a, T5's numeral and S3's count are three consumers of one computation.
That is a good position — it means the next session has exactly one target — but it also
means no amount of S-cluster work substitutes for it.
