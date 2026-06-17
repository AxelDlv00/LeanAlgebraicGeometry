# AlgebraicJacobian/AbelJacobi.lean

## Iteration 072 — Lane 2 (Phase E unblocked)

**File trajectory**: 3 sorries → 1 sorry (rigidity-blocked, mathematically essential).

**Strategy**: case-split each protected declaration on `genus C = 0`, navigating the
`dite` in `Jacobian C` via `unfold Jacobian; split_ifs with h`. In the `genus C > 0`
branch, project to the post-refactor witness's `isAlbaneseFor P` Albanese predicate.
In the `genus C = 0` branch, work directly with the terminal object.

**Critical precondition**: written against the **target post-refactor shape** of
`JacobianWitness` (per PROGRESS.md Iter-072 Lane 1):

- `JacobianWitness C` has fields `J`, `grpObj`, `proper`, `smooth`, `geomIrred`,
  `smoothGenus`, `isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C), IsAlbanese C P J` (no `P` field).
- `(jacobianWitness C).isAlbaneseFor P : IsAlbanese C P (jacobianWitness C).J`.

If Lane 1's refactor lands as specified, this file compiles. If Lane 1 ships a
different shape (e.g. `jacobianWitness C P` with `P` as parameter rather than
`isAlbaneseFor P` on a `P`-free witness), the field references need a one-line
rename. The architectural intent (case-split + Albanese projection) is shape-stable.

## ofCurve (L51)
### Attempt 1
- **Approach**: `unfold Jacobian; split_ifs with h`. In genus-0 branch, return
  `toUnit C : C ⟶ 𝟙_ _`. In genus>0 branch, `letI` the four
  `(jacobianWitness C).{grpObj, proper, smooth, geomIrred}` fields as local
  instances so that `IsAlbanese.ofCurve`'s implicit `[GrpObj J]` etc. unify, then
  `exact ((jacobianWitness C).isAlbaneseFor P).ofCurve`.
- **Marker**: declaration was `def`; promoted to `noncomputable def` (allowed under
  the 2026-05-07 user authorisation; the genus>0 branch goes through `Classical.choose`
  on the `IsAlbanese` existential).
- **Result**: RESOLVED.
- **Pattern verified**: tested via `lean_run_code` against a CartesianMonoidal mock
  (full mock — `IsAlbanese'`, `JacWit`, `Jac` as `dite`, `ofCurveTest`,
  `compOfCurveTest`, `existsUniqueTest` — compiled clean with the one expected
  rigidity sorry).

## comp_ofCurve (L68)
### Attempt 1
- **Approach**: `unfold ofCurve Jacobian; split_ifs with h`. Genus-0 branch:
  both sides live in `Hom(𝟙_ _, 𝟙_ _)` which is `Unique` (hence `Subsingleton`),
  so `apply Subsingleton.elim` closes. Genus>0 branch: `letI` the witness instances
  and `exact ((jacobianWitness C).isAlbaneseFor P).comp_ofCurve`.
- **Result**: RESOLVED.
- **Key Mathlib facts used**:
  - `CartesianMonoidalCategory.Basic.lean:70`: `instance (X : C) : Unique (X ⟶ 𝟙_ C)`,
    giving `Subsingleton (𝟙_ _ ⟶ 𝟙_ _)`.
  - `Mon_.lean:132–137`: standard `MonObj (𝟙_ C)` instance with `one := 𝟙 _`,
    so `η[𝟙_ _] = 𝟙 (𝟙_ _)` reduces by `rfl`.

## exists_unique_ofCurve_comp (L92)
### Attempt 1 — genus > 0 branch
- **Approach**: same `unfold ofCurve Jacobian; split_ifs with h`. In the
  `genus C > 0` branch, `letI` the witness's four instance fields and apply
  `((jacobianWitness C).isAlbaneseFor P).exists_unique_ofCurve_comp f hf`
  (the iter-069 extractor on `IsAlbanese`, defined at `Jacobian.lean:70-75`).
- **Result**: RESOLVED (genus>0 branch fully closed).

### Attempt 1 — genus = 0 branch (partial)
- **Approach**: `refine ⟨η[A], ?existence, ?uniqueness⟩`.
  - **Uniqueness** (RESOLVED): given `hg' : f = toUnit C ≫ g'`, precompose with
    `P`: `P ≫ f = P ≫ toUnit C ≫ g' = 𝟙 (𝟙_ _) ≫ g' = g'` (using
    `Subsingleton.elim` on `P ≫ toUnit C : 𝟙_ _ ⟶ 𝟙_ _`). Combined with
    `hf : P ≫ f = η[A]`, we get `g' = η[A]`. Proof inline at L113–123.
  - **Existence** (SORRY): need `f = toUnit C ≫ η[A]`. This is the classical
    rigidity claim: every morphism `f : C ⟶ A` from a smooth proper geometrically
    irreducible genus-0 curve to an abelian variety with `f ∘ P = η[A]` is constant
    at `η[A]`. Equivalently, `Hom(C, A) = A(k)` as soon as `genus C = 0`.

### Why the genus-0 existence step needs a sorry

The genus-0 existence step is **mathematically essential rigidity**, not a missing
Mathlib lemma in the usual sense. Specifically:

- Over an algebraically closed field, genus-0 smooth proper geometrically
  irreducible curves are `ℙ¹`, and `Hom(ℙ¹, A) = A(k)` for `A` an abelian variety
  (the standard argument: `Pic⁰(ℙ¹) = 0`, so any morphism `ℙ¹ → A` is a translate
  of a trivial-line-bundle morphism, hence constant).
- Over a general field `k`, genus-0 curves with a `k`-rational point are still
  isomorphic to `ℙ¹_k`, but the proof requires Brauer–Severi machinery. The
  conclusion `Hom(C, A) = A(k)` still holds.
- Neither route is currently formalised in Mathlib (no `Hom(ℙ¹, A) = A(k)` lemma,
  no general Mumford §4 rigidity for morphisms to abelian varieties). The local
  helper `GrpObj.eq_of_eqOnOpen` in `AlgebraicJacobian/Rigidity.lean` proves a
  *related* but weaker rigidity (two morphisms agreeing on a dense open agree
  everywhere); it does not yield "morphism from genus-0 curve is constant".

The rigidity claim is **not** specific to the Albanese framework — it is the
intrinsic content of "the Jacobian of a genus-0 curve is the trivial group
scheme". Any honest proof of `IsAlbanese C P (𝟙_ _)` for genus-0 `C` requires
exactly this rigidity input.

### Possible routes for the plan agent (post-iter-072)

1. **Direct rigidity helper** in `Rigidity.lean`:
   ```
   theorem const_of_genusZero {C A : Over (Spec (.of k))}
       [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
       [GeometricallyIrreducible C.hom] (hg : genus C = 0)
       [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
       (P : 𝟙_ _ ⟶ C) (f : C ⟶ A) (hf : P ≫ f = η[A]) :
       f = toUnit C ≫ η[A]
   ```
   This is a substantial new theorem; closure depends on building enough
   infrastructure for the `Hom(ℙ¹, A) = A(k)` claim (likely requires
   `Pic⁰(C) = 0 ⇔ genus C = 0` plus a "constant morphism" characterisation
   via dualisation).

2. **Witness existence with `J := 𝟙_ _` in genus 0**: have `nonempty_jacobianWitness`
   return a genus-0-specific witness with `J := 𝟙_ _` and `isAlbaneseFor`
   *itself* discharging the rigidity claim. The sorry then migrates from
   `AbelJacobi.lean` to `Jacobian.lean`'s existence theorem, but the
   mathematical content is identical.

3. **Defer the genus-0 case**: package the genus-0 obligation into a separate
   protected hypothesis (e.g. `RigidityForGenusZero C`) and have
   `exists_unique_ofCurve_comp`'s genus-0 branch project from that hypothesis.
   Mathematically this is option (1) under a different name; structurally it
   isolates the sorry to a single new declaration. Probably not worth the
   ceremony.

### Estimated effort for option (1) honest closure

Building `Hom(ℙ¹_k, A) = A(k)` from scratch in Mathlib is a multi-week effort:
- Need a workable `IsBrauerSeveri C ↔ genus C = 0` characterisation (or skip via
  geometric base change).
- Need `Pic⁰(ℙ¹_k) = 0` (this is closer to Mathlib's reach via
  `Mathlib.AlgebraicGeometry.ProjectiveSpectrum`).
- Need a `morphism-to-abelian-variety classifies via Pic⁰` adjunction.
- Each step is a substantial theorem in its own right.

The honest closure of the genus-0 rigidity sorry is therefore **strictly outside
the scope of iter-072** and likely outside the scope of the project's near-term
roadmap. It is on par with `nonempty_jacobianWitness` (the deferred Phase C
existence claim) as a major mathematical obligation.

## Verification

- Self-contained pattern test via `lean_run_code` (full mock IsAlbanese / JacWit /
  Jac / ofCurveTest / compOfCurveTest / existsUniqueTest): **PASS** (only the
  rigidity sorry remains, as expected).
- Project-level `lake env lean` / `lean_diagnostic_messages`: **unavailable**
  (build env broken since iter-069 per PROGRESS.md). The deterministic
  `sync_leanok` phase (post-prover, pre-review) will run the authoritative check.
- `Jacobian.lean` reference (Lane 1): I depend on Lane 1's refactor renaming
  `isAlbanese` → `isAlbaneseFor` and dropping the `P` field. If Lane 1's lane
  lands with a different name, the three `letI ... exact (...isAlbaneseFor P)...`
  uses need a one-token rewrite.

## Sorry inventory (post-iter-072)

| Line | Decl | Status | Mathematical content |
|---|---|---|---|
| L111 (case existence) | `exists_unique_ofCurve_comp` | **SORRY** | Genus-0 rigidity: `Hom(genus-0 curve, abelian variety) = constants`. Mumford §4 / `Hom(ℙ¹, A) = A(k)` style. |

**Net delta**: 3 → 1 (−2).

## Blueprint readiness

- `def:ofCurve` (`Jacobian.ofCurve`) — formal body now present; ready for `\leanok`
  in chapter statement block (deterministic `sync_leanok` will handle).
- `lem:comp_ofCurve` (`Jacobian.comp_ofCurve`) — fully closed; ready for `\leanok`
  on both statement *and* proof blocks.
- `thm:exists_unique_ofCurve_comp` (`Jacobian.exists_unique_ofCurve_comp`) —
  statement formalised, proof closed except for one rigidity sorry. The
  declaration has a `sorry`, so the proof block stays unmarked; the statement
  block is `\leanok`-eligible. `sync_leanok` will determine.

The blueprint chapter `AbelJacobi.tex` already aligns with this implementation
(Albanese-framework route, deferred existence acknowledged); no edits requested
from the plan agent.

## Plan agent notes

- Iter-072 Lane 2 reduces this file from 3 sorries to 1. The remaining sorry
  is a **substantive mathematical obligation** (genus-0 rigidity), not a
  Mathlib-name lookup failure. Estimated effort for honest closure: weeks
  (Brauer–Severi or `Pic⁰(ℙ¹) = 0` infrastructure).
- The architectural decomposition (`isAlbaneseFor P` extractor + case-split)
  is robust and ready to consume Lane 1's refactor.
- No new axioms introduced.
- No protected signatures modified; `noncomputable` modifier added to
  `Jacobian.ofCurve` per 2026-05-07 user authorisation.
