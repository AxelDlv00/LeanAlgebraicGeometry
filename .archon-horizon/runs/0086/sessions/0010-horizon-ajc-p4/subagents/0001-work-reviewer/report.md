Those other `/tmp/rev_*` files belong to other reviewer sessions; mine are gone. `rev_probe_p3h.lean` at the workspace root predates me (it was in the initial git status).

## Verdict

**Converging on three theorems, churning on two.** The commit's real content is Milne 3.1 over a perfect field — genuinely new, nowhere in AJC/AJCR/Albanese/mathlib. But two of the five re-derive lemmas already landed, one of them from inside the file's own import closure, and the file's headline negative cites a declaration that does not exist. The pattern is I-1284's exactly: everything true, everything axiom-clean, and 40% of the declarations adding nothing.

---

### 1. VACUITY — **REFUTED** (your claim stands; the binders are inhabitable)

I could not break this. `Adelic.p1Over ℚ` discharges all seven instances (`Smooth`, `GeometricallyIrreducible`, `IsSeparated`, `LocallyOfFiniteType`, `IsIntegral`, `IsReduced`, `IsProper`) by pure synthesis, and I instantiated **all five** theorems at it — each axiom-clean `[propext, Classical.choice, Quot.sound]`. No binder forces closure. `PerfectField` is genuinely weaker as used: I-1302's probes confirm the perfect-field regularity delegate at `SmoothPrimeRegularity.lean:665` asks only `[PerfectField k]` and is sorry-free (0 sorries in that file).

Your own later commit eba86a9947 (`Albanese/CodimOnePerfectFieldWitness.lean`, not in the audited pair) already does this at ℚ and 𝔽₅. That file is the right answer to this question and it exists.

No gate binder anywhere in the file — no `HasPicSchemeEt`, nothing whose instance projects a sorry. The I-1282/I-1283 failure mode does not apply.

### 2. DUPLICATION — **CONFIRMED as a real problem** (two of five)

`isReduced_of_smooth_perfectField` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/CodimOnePerfectField.lean:160`) is **dead**. `AlgebraicGeometry.Smooth.isReduced_of_field` (`.../AlgebraicJacobian/Curve/GeometricallyReduced.lean:114`) proves the same conclusion over an **arbitrary** field with the same single `[Smooth X.hom]` binder. It is in your closure, reached `CodimOneExtension → WeilDivisor → ResidueOneAlgClosed → ChiCurve → GeometricallyReduced`. Verified by elaboration:

```lean
theorem revA {k : Type u} [Field k] (X : Over (Spec (.of k))) [Smooth X.hom] :
    IsReduced X.left := AlgebraicGeometry.Smooth.isReduced_of_field X.hom
-- axiom-clean
```

Your 30-line stalkwise proof and the docstring paragraph explaining why it "needed a **different route**" are both re-deriving that. The docstring reasoning is correct about `isReduced_of_isStandardSmooth_of_isAlgClosed` and irrelevant to the goal.

`isRegularLocalRing_stalk_of_smooth_perfectField` (`:113`) duplicates `Scheme.isRegularLocalRing_stalk_of_smooth_of_perfectField` (`.../AlgebraicJacobian/Picard/Pic0Dimension.lean:90`, commit b653ef4d6c, lane `ajc-pic0av`, 2026-07-29) which is **strictly stronger** — `GeometricallyIrreducible`, `IsSeparated`, `LocallyOfFiniteType`, `IsIntegral`, `IsReduced` all absent. Your statement closes in one line by it. That commit's message states your widening in your words: "AJC already had this but only over k-bar and with five further binders."

The remaining three (`:202`, `:253`, `:347`) have no predecessor anywhere. Milne 3.1 is `[IsAlgClosed]`-only in AJC (`CodimOneExtension.lean:1491`), AJCR (`CodimOneMilne31.lean:121`) and Albanese (`CodimOneExtension.lean:1431`). Those three are the throughput.

### 3. THE NEGATIVE — **CONFIRMED as fact, REFUTED as a census**

The non-widening is real. Milne 3.3 over `PerfectField`, closed by its core, fails `failed to synthesize instance of type class IsAlgClosed k`. `mem_domain_of_selfDiag_mem_domain` fails the same way, and `pointOfClosedPoint` does need `[IsAlgClosed K]` (`.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AlgClosed/Basic.lean:52`, via `residueFieldIsoBase` → `IsAlgClosed.ringHom_bijective_of_isIntegral`).

But **you did stop at the first one you found.** There is a second, independent consumption site in the same cone: `Milne33Transport.lean:305-308` calls `isRegularLocalRing_stalk_of_smooth` (the `[IsAlgClosed]` form) twice to build `hregY`/`hregX`, and `:283` calls `isIntegral_pullback_self` (`CodimOneExtension.lean:938`), which is `[IsAlgClosed]` and routes through `isReduced_of_smooth_of_isAlgClosed`. Both are **repairable, and cheaply** — which strengthens your conclusion rather than weakening it:

- the regularity calls → your own `:113` (or Pic0Dimension's);
- `isIntegral_pullback_self` → I proved it at an **arbitrary** field, axiom-clean, by swapping in `Smooth.isReduced_of_field`.

So the residue really is the row argument alone. Your prose asserts that; it was not measured before now.

The census is wrong twice. "Nine of the twelve modules carry no `IsAlgClosed`" counts the twelve `Milne33*` + `DifferenceMap` + `PolePurity` files, not the cone. The actual `Milne33` import closure is 69 project modules, 20 under `Albanese/`; **six** carry `IsAlgClosed` — your three plus `CodimOneExtension`, `RiemannRoch/Ledger/ResidueOneAlgClosed`, `RiemannRoch/WeilDivisor`. And module-level grep is the wrong instrument for exactly the reason you suspected: `Milne33Transport` consumes it *through* `CodimOneExtension`, and its own single hit is a `variable` line.

### 4. THE CORRECTION — **CONFIRMED**

Both halves of I-1115 are wrong as written, and your characterisation is accurate, not overstated. I-1115's third bullet names `isRegularLocalRing_localizationAtPrime_of_isStandardSmooth_of_isAlgClosed` (`CodimOneExtension.lean:806`) as the regularity input to the coheight-≥2 argument. It is not: `isRegularLocalRing_stalk_of_smooth` calls `..._of_perfectField` (line 1284). I-1115 measured the closed-point lemma and attributed it to a chain that does not use it. And Milne 3.3 does bind `IsAlgClosed` (`Milne33.lean:58`, variable line).

The narrower reading that survives: "the binder is load-bearing on Milne 3.1's *declaration*" is true — it is written there, and `PerfectField` is not `Field`, so the headline's arbitrary-field target is still not met. Your file says this.

### 5. AXIOM/SORRY — **CONFIRMED**

Reproduced independently. `lake build AlgebraicJacobian.Albanese.CodimOnePerfectField` EXIT=0 (8627 jobs) first, then `#print axioms` on all five: `[propext, Classical.choice, Quot.sound]`. Control `AlgebraicGeometry.isAlbanese_pic0Et` fires `sorryAx`. (`fgaPicardRepresentability` is not a real constant — the seam is `Scheme.instHasPicSchemeEt`, `FGAPicRepresentability.lean:745`; your commit message names a nonexistent control.) No gate binder in the file; all five stay clean when instantiated at `p1Over ℚ`.

### 6. OVERCLAIM — **partly CONFIRMED, partly REFUTED**

The "closes nothing" docstring is accurate and I found no overclaim about the Jacobian. Two concrete false statements though:

- `:64` names `milne33_needs_isAlgClosed` as "a documented negative" and `:42` says "§2 records the refuting probe". **No such declaration exists** (`#check` → unknown constant; one grep hit, the docstring itself), and there is no §2 code — the file ends after theorem 5. The negative is prose. This is your own filed lesson `cited-names-need-check-not-grep`, reproduced.
- The commit message's `fgaPicardRepresentability` control does not exist.

Plainly, on content vs re-hypothesis: **three of the five are content**, two are not. `:202`/`:253`/`:347` are a real widening of Milne 3.1 with no predecessor — that is worth reporting. `:113` and `:160` are a re-hypothesis of landed work with a *stronger* binder set than what already exists; `:160` is dead against an arbitrary-field theorem in your own closure.

Filed: **I-1302** (issue, the three findings) and **I-1303** (memory — a widening authored by transcribing the `[IsAlgClosed]` original makes that original the only comparison point you load, which is what hid both duplicates).
