Both inbox items landed (I-0669 issue, I-0670 memory).

## Verdict: CONVERGING — real progress, not faked

This is the strongest single-round result I have reviewed on this lane. The claim "the per-σ mate obligation was already a theorem in this project" is true, the throughput is real (one of three obligations closed outright, three sessions of proposed `mateEquiv_vcomp`/`TwoSquare` work retired as unnecessary), and the endpoint's improvement is a strict one with no hypothesis inflation. Two defects, both docstring-level, neither touching a proof term.

## Claims 1–5, individually

| # | Claim | Verdict |
|---|---|---|
| 1 | `cechOuterBC … = canonicalBaseChangeMap h` by `rfl` | **CONFIRMED** — elaborates |
| 2 | `canonicalBaseChangeMap_isIso` axiom-clean | **CONFIRMED** — `[propext, Classical.choice, Quot.sound]`; whole 6-module cone = 840 decls, **zero** sorry-tainted |
| 3 | Per-σ obligation is one application, no mate calculation | **CONFIRMED** |
| 4 | `oneLeaf` hypotheses IDENTICAL, both leaves absent | **CONFIRMED** |
| 5 | Cone sorry-free, no import cycle | **CONFIRMED** |

On (a), which you asked me to attack hardest: I did not eyeball. `example : @cech_flatBaseChange = @cech_flatBaseChange_oneLeaf := rfl` elaborates, which fails on *any* binder difference. The only textual delta is the binder *name* `h𝒰`, which does not enter the type. `QuasiSeparated` is **not** on the endpoint — it appears on the intermediate `isIso_cechOuterBC_*` lemmas, and mathlib's `Separated.lean:67` instance derives it from `[IsSeparated f]`; a probe that omits it elaborates. No overclaim of the recorded shape.

On (b) I went past the diff. Note a trap that made my first two probes lie: a constant-closure walk seeded at a **theorem** returns a vacuous answer, because an imported theorem's `value?` is `none` — my first run reported "sorryAx not in closure" for a declaration that demonstrably depends on it. Seeded at the defs, the closure of `cech_flatBaseChange_oneLeaf` contains `twisted_cech_nerve_iso` and *not* `cech_pushforward_baseChange_natIso`, `pullback_preservesMonomorphisms`, `pullback_preservesFiniteLimits`, `pullback_preservesHomology`, or `pullback_mapHC_homologyIso`. Then the decisive test: I restated the endpoint with the twisted-nerve iso as an explicit hypothesis and rebuilt the same term — **axiom-clean**. So "exactly one leaf" is not an inference from absence, it is proved.

On (c): not vacuous. `isIso_cechOuterBC_coverInter` and `isQuasicoherent_pushPullObj_coverInter` both instantiate on `Spec R` with identity maps and `κ = Fin 1`. `isIso_app_of_iso_obj` **is** in mathlib as `CategoryTheory.NatTrans.isIso_app_iff_of_iso` (`MorphismProperty/Basic.lean:761`) — it is literally its `.mpr`. Harmless duplication; the docstring calling it "the bridge that lets…" overstates novelty.

On (d): both cited labels resolve (`thm:quot_canonical_basechange_isIso` at `blueprint/src/chapters/Picard_QuotScheme.tex:7469`, `lem:openimm_beckchevalley` at `Cohomology_CechHigherDirectImage.tex:13030`), both targets are sorry-free, no DAG cycle from the new edges, and the retargeted `\leanok` is honest.

## The two defects (filed as I-0669)

**Phantom declaration name.** `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean:1985` advertises `isQuasicoherent_cechNerve_obj`, which does not exist anywhere in the project — that line is its only occurrence. This is the recorded "docstring declaration lists are unchecked" failure, sitting inside the note whose entire subject is an unchecked absence claim that cost three sessions.

**One stale sentence.** Same file, `:2962-2965`: `cechComplex_baseChange_iso` "still carries a cosimplicial naturality `sorry` — as of run 0068 r3 exactly one". Measured false: that declaration still reaches **both** leaves. Only `cechComplex_baseChange_iso_flat` has one. True of what the reader should use, false of the declaration it names.

## Not a defect but worth knowing

The r3 route makes 55 in-module declarations dead weight relative to the live path — the whole `pushPullObj_coverInter_baseChange` / `_spec` / tilde-bridge chain that the superseded `natIso` consumed. They are sorry-free and still compile, so this is not churn, but a future session should decide whether that layer is retained deliberately or is now maintenance-only.

Also: `scripts/axiom-frontier.lean` cannot be run whole (it imports a root rollup, and `RiemannRoch/Adelic/NonconstantToP1.olean` was absent under concurrent lane builds). The lane said so and measured from a minimal-import scratch file instead — the right call, honestly reported, and I reproduced its numbers that way.
