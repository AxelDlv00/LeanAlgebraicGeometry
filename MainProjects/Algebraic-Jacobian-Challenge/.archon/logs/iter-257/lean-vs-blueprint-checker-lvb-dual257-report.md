# Lean ↔ Blueprint Check Report

## Slug
lvb-dual257

## Iteration
257

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`)
- **Lean target exists**: yes (L291)
- **Signature matches**: yes — `(dual M).restrict f ≅ dual (M.restrict f)` for `f : Y ⟶ X` open immersion, `M : X.Modules`; matches blueprint statement.
- **Proof follows sketch**: partial — Steps 1–4/H1 match blueprint (restrictFunctorIsoPullback → sheafificationCompPullback → strip → H1 via pushforwardPushforwardAdj + leftAdjointUniq). **Structural divergence in the Step-4 assembly** (see Red Flags §1 below).
- **Markers**: blueprint has `\leanok` on statement block only — correct; declaration exists with two sorries.
- **Notes**:
  - Two live sorries: `sliceDualTransport` body (L210) and `dual_restrict_iso` naturality square (L323).
  - The naturality square sorry is conditioned on `sliceDualTransport` becoming concrete; it cannot be discharged until `sliceDualTransport` is filled.
  - In-file docstring acknowledges both sorries explicitly.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `lem:dual_unit_iso`)
- **Lean target exists**: yes (L341)
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`.
- **Proof follows sketch**: yes — sheafifies `presheafDualUnitIso` (= `dualUnitIsoGen`) via sheafification mapIso + sheafification adjunction counit; matches blueprint "evaluation-at-1 / sheafify" description (L5742–5755). Axiom-clean.
- **Markers**: blueprint has `\leanok` on statement at L5726 — correct (declaration is fully proved).

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`)
- **Lean target exists**: yes (L399)
- **Signature matches**: yes — `LineBundle.IsLocallyTrivial L → LineBundle.IsLocallyTrivial (dual L)`.
- **Proof follows sketch**: yes — exactly the three-step chain from blueprint §5.4 (L5789–5810):
  `dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso`.
  Compiled and correct structurally; transitively sorry via `dual_restrict_iso`.
- **Markers**: blueprint has `\leanok` on statement at L5760 — correct (declaration exists with transitively-sorry body).

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `lem:scheme_modules_hom_local_section`)
- **Lean target exists**: yes (L422)
- **Signature matches**: yes — matches blueprint L5885 description precisely.
- **Proof follows sketch**: yes — eqToHom-conjugation, naturality by `Subsingleton.elim`. Axiom-clean.
- **Markers**: blueprint has `\leanok` on statement at L5882 — correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `lem:sheafofmodules_hom_of_local_compat`)
- **Lean target exists**: yes (L580). **CLOSED (iter-256), axiom-clean.**
- **Signature matches**: yes — sectionwise hf overlap form matches blueprint (iter-254 re-sign is blueprinted).
- **Proof follows sketch**: yes — two-step (glue ab-sheaf morphism via existsUnique_gluing + promote via homMk); the smul-bridge sub-step follows blueprint. Axiom-clean.
- **Markers**: blueprint has `\leanok` on statement at L5935 — correct.

---

## Red Flags

### Placeholder / suspect bodies

1. **`sliceDualTransport` at L171–210: body is `:= sorry`, blueprint claims substantive construction.**

   `sliceDualTransport` is the load-bearing piece of `dual_restrict_iso` Step-4.  Its body
   is an acknowledged placeholder; the in-file comment supplies a 30-line construction plan
   describing the intended ~200-LOC build.  This is a **must-fix-this-iter** sorry (the
   iteration objective).

2. **`dual_restrict_iso` naturality square at L323: body is `:= sorry`, downstream of `sliceDualTransport`.**

   The `isoMk` naturality square for `dual_restrict_iso` is left as `sorry` because it cannot
   be discharged until `sliceDualTransport` has a concrete hom.  Once `sliceDualTransport` is
   filled this reduces to a `Subsingleton.elim` or trivial poset coherence.  This sorry is a
   **must-fix-this-iter** item (but is unblocked immediately once (1) above is resolved).

### Structural divergence: Lean assembly vs. blueprint description

**Finding**: The blueprint (L5673–5675) explicitly says:

> "the Step-4 residual is then `isoMk` of the composite (leg (A) `sliceDualTransport`) **followed by** (leg (B), `restrictScalarsRingIsoDualEquiv`)"

This prescribes the `dual_restrict_iso` Step-4 assembly as
`isoMk (fun V => sliceDualTransport f M V ≪≫ restrictScalarsRingIsoDualEquiv_at_V ...)`.

But the **current Lean** (L321) has:
```
refine PresheafOfModules.isoMk (fun V => sliceDualTransport f M V) ?_
```
with `sliceDualTransport`'s construction plan (L179–210) folding **both** leg (A) (slice
reindexing via `f.opensFunctor`) **and** leg (B) (post-composition with `(f.appIso W').hom`,
the presheaf shadow of `restrictScalarsRingIsoDualEquiv`) into a single helper.

The two approaches are mathematically equivalent but structurally different:

| | `sliceDualTransport` covers | `dual_restrict_iso` Step-4 assembly |
|---|---|---|
| Blueprint prescription | leg (A) only | `isoMk (sliceDualTransport ≪≫ leg(B))` |
| Lean in-file plan | leg (A) + leg (B) | `isoMk sliceDualTransport` |

**Impact**: A prover building `sliceDualTransport` strictly from the blueprint (leg A only) would
produce a helper whose return type covers only the slice reindexing; the `dual_restrict_iso` Step-4
would then fail to typecheck as written (missing the leg-B `restrictScalarsRingIsoDualEquiv` application
in the outer assembly). Conversely, a prover building `sliceDualTransport` per the in-file plan
((A)+(B)) will find that the `dual_restrict_iso` assembly `isoMk sliceDualTransport` typechecks
but the blueprint's described extension step is vacuous.

Since `sliceDualTransport` is still `sorry`'d, the prover's in-file comment is the authoritative
guide for this iteration.  The blueprint description is **stale / inconsistent** with the actual
Lean structure and should be updated.

**Classification: major** (the in-file comment over-rides for the current prover; blueprint must be
corrected before future provers touch this file).

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` reference in the blueprint.
All are helpers; none are substantive enough to require blueprint promotion except where noted.

| Declaration | Line | Notes |
|---|---|---|
| `PresheafOfModules.unitDualSectionEquiv` | L66 | helper for `dualUnitIsoGen`; not needed blueprint-side |
| `PresheafOfModules.dualUnitIsoGen` | L108 | presheaf-level §0 helper; feeds `presheafDualUnitIso` |
| `Scheme.Modules.sliceDualTransport` | L171 | **load-bearing sub-build for Step-4 of `dual_restrict_iso`**; currently sorry-bodied; the blueprint describes it conceptually (L5658–5678) but has no `\lean{...}` pin — acceptable as helper, but blueprint adequacy analysis below applies |
| `Scheme.Modules.presheafDualUnitIso` | L330 | thin wrapper on `dualUnitIsoGen`; used by `dual_unit_iso` |
| `Scheme.Modules.topSectionToHom` | L479 | helper for `homOfLocalCompat` gluing step |
| `Scheme.Modules.topSectionToHom_app` | L492 | companion lemma to above |
| `Scheme.Modules.image_preimage_of_le` | L503 | simp lemma; blueprint mentions but does not give `\lean{}` pin (acceptable) |

---

## Blueprint adequacy for this file

### Coverage
5/5 main declarations (`dual_restrict_iso`, `dual_unit_iso`, `dual_isLocallyTrivial`,
`homLocalSection`, `homOfLocalCompat`) have `\lean{...}` blueprint blocks.  Unreferenced
declarations: 7 helpers (acceptable — all are clearly support structure).

### Proof-sketch depth

**`dual_restrict_iso` Steps 1–3 and H1**: adequate.  The blueprint describes each step and H1
clearly (L5611–5634); the Lean follows them exactly.

**`sliceDualTransport` leg (A) body**: adequate for leg (A) only.  The blueprint (L5658–5678)
names the key ingredients for the eqToHom-conjugation: `Functor.FullyFaithful.homEquiv`,
`image_preimage_of_le`, `Subsingleton.elim` naturality, and the `isoMk` packaging pattern.
This is detailed enough to guide a ~100-LOC construction of the leg (A) reindexing.

**`sliceDualTransport` leg (B) content**: under-specified relative to the Lean plan.  The blueprint
says leg (B) = `restrictScalarsRingIsoDualEquiv` applied AFTER `sliceDualTransport` in the outer
assembly, but the in-file plan places leg (B) INSIDE `sliceDualTransport` (post-composition by
`(f.appIso W').hom` at each component, plus the `map_smul'` linearity argument via the ring iso).
A prover relying solely on the blueprint for the `sliceDualTransport` body would not know to include
leg (B) content there.

**`dual_isLocallyTrivial` three-step chain**: adequate — blueprint §5.4 (L5789–5810) is precise and
exactly mirrored in Lean.

**`dual_unit_iso` sketch**: adequate — evaluation-at-1 argument described clearly.

**`homOfLocalCompat` gluing engine**: adequate — already closed; not a concern for this iter.

### Hint precision
- `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}`: precise.
- `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}`: precise.
- `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}`: precise.
- `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}`: precise.
- `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}`: precise.

No `\lean{...}` for `sliceDualTransport` — acceptable for a helper, though the blueprint is the
primary documentation for it.

### Generality
Matches need for all declarations.

### Recommended chapter-side actions

1. **Update the `lem:dual_restrict_iso` proof text** to reflect the actual Lean assembly:
   - Option A (matches Lean in-file plan): Change the Step-4 description from
     "`isoMk` of the composite (leg A `sliceDualTransport`) followed by (leg B, `restrictScalarsRingIsoDualEquiv`)"
     to "`isoMk sliceDualTransport`", and update the `sliceDualTransport` description to say it
     incorporates both the leg-(A) slice reindexing AND the leg-(B) `(f.appIso W').hom` post-composition
     (the `map_smul'` bridge) internally.
   - Option B (matches blueprint prescription): Change the Lean `dual_restrict_iso` assembly from
     `isoMk sliceDualTransport` to `isoMk (fun V => sliceDualTransport f M V ≪≫ ...)` with a
     separate `restrictScalarsRingIsoDualEquiv`-at-V application, and strip leg (B) from
     `sliceDualTransport`'s construction plan.

   Either option resolves the divergence; Option A has less Lean churn since `sliceDualTransport`'s
   sorry-body comment already describes (A)+(B).

2. **Add a `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` pin** to the blueprint's
   "leg-(A) atom" paragraph (L5658) for traceability, even as a helper — the ~200-LOC body is
   substantive enough to warrant a blueprint anchor.

---

## Severity summary

| Finding | Severity |
|---|---|
| `sliceDualTransport` body `:= sorry` (load-bearing Step-4 piece) | **must-fix-this-iter** |
| `dual_restrict_iso` naturality square `:= sorry` (conditioned on sliceDualTransport) | **must-fix-this-iter** |
| Blueprint prescribes `isoMk (sliceDualTransport ≪≫ leg B)` but Lean has `isoMk sliceDualTransport` with (A)+(B) inside | **major** (blueprint stale; in-file comment guides current prover correctly) |
| No `\lean{...}` pin for `sliceDualTransport` | **minor** |

**Overall verdict**: Two must-fix sorries remain in `sliceDualTransport` and the `dual_restrict_iso`
naturality square; 3 declarations are axiom-clean (`dual_unit_iso`, `dual_isLocallyTrivial`,
`homOfLocalCompat`); blueprint Step-4 assembly description is stale relative to the Lean plan
and should be updated before the next prover pass on this file.
