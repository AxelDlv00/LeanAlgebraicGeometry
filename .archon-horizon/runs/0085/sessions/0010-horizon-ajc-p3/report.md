Confirmed: `GaloisSelfTensor.lean` is p1's live work-in-progress (its last commits are p1's, including one reverting a clobber). Committing another lane's in-flight file is exactly the hazard I filed I-1393 about, so I leave it.

Everything I authored is committed and verified at HEAD. The only file-mutating tool use after my last ledger commit was writing my memory file, which lives outside the ledger work tree (`/home/axel/.claude-api/...`, not `/home/axel/LeanAlgebraicGeometry-Horizon`) and so produces no durable ledger change.

## Progress

- `AlgebraicJacobian/Curve/GaloisLevelRationalPoint.lean` (new, rooted at `AlgebraicJacobian.lean:60`): 0 → 342 lines, **8 declarations, zero code sorries** (the 2 `sorry` strings are docstring prose), every declaration axiom-clean `[propext, Classical.choice, Quot.sound]` against **two** controls that both correctly fire `sorryAx` — `fgaPicardRepresentability` and `picardJacobianWitness`. Root `lake build` EXIT=0 (8879 jobs).
  - `exists_finiteGalois_level_hasRationalPoint_of_geometricallyIrreducible` — the deliverable: for a smooth geometrically irreducible curve over an **arbitrary** field `k`, a finite **Galois** `k''/k` inside `k^s` with `Scheme.HasRationalPoint (baseChangeField C k'')`. **No antecedent** beyond the curve binders, no hypothesis on `C(k)` (`I-0491`). Plus the `GeometricallyIntegral` spelling, the `LocallyOfFiniteType` generalisation, the pullback-section brick, two non-vacuity witnesses, and §5's consumer into `G2`'s affine quotient engine.
- **Board**: `AJC.picrep.sepclosed-galois` → **done**, owner cleared, pinned `71b1eea9af`, verified at HEAD with `git show HEAD:`. Five commits: `bd7841b83c`, `a1e9ac7811`, `71b1eea9af`, `cd7a7515f9`, `39f8867b38`.

**Which item and why third.** Input (4) of the seam's four-input descent-repair scoreboard — the only one of the four whose residue was a single named statement rather than a scheme construction, and the successor row my own r4 opened and left explicitly **unpriced**. p1 held the Galois quotient/splitting, p2 the invariance step, p4 obligation 5; nobody held this.

**State: closed sorry-free, every antecedent witnessed.** The `k^s`-point that §2 takes as a hypothesis is *produced* by `SeparablyClosedRationalPoint.lean` from the curve binders alone, so §3 is a theorem about curves, not an implication. Non-vacuity is compiler-checked twice: at the headline's own binders (with a guard that bites) and at `ℙ¹_ℚ` as a concrete inhabitant. **It closes no antecedent of the seam** — G1 still needs the *datum* at that level, `k'`-side representability is the campaign's undischarged output, `G2(c)`'s glued half is untouched.

## Issues

- **My row's own price was wrong and I set it.** "Unpriced" cost three mathlib instances plus one `Spec.map_comp` triangle — no filtered colimit, no descent, no separability re-run.
- **Two of my docstring claims were refuted by an audit I commissioned against myself** (`I-1375`/`I-1376`), both fixed at `39f8867b38`: §4's "compiler-checked" heading sat over a *hand-transcribed* binder list, since `picardJacobianWitness` was not in the file's import closure; and I wrote that a dead pointer "is not repeated here" then repeated it three times below. The repair has a trap I hit first — putting the headline's *witness term* in a proof fires `sorryAx`; binding its *type* does not. Lesson filed as `I-1394`.
- **`I-1373`**: four `.lean` sites including the seam docstring cite `AlgebraicJacobian/Challenge.lean`, which does not exist; `ChiCurve.lean:11` already said so and nothing propagated it.
- **`I-1393`**: 24 unrooted scratch files, three containing `sorry`, are now at HEAD in AJC, so any `grep`-based sorry census disagrees with the build by construction. Not deleted — that blast radius belongs to the reviewer or the human.
- **My §5 reached HEAD via another lane's integrate sweep**, so my own commit found nothing to stage. Content verified intact by sha256 and by enumerating all 8 declarations at HEAD.
- Two upstream modules failed once under parallel build contention; both rebuilt clean in isolation.

## Why I stopped

The claimed item is fully complete, audited adversarially with fresh context, both findings repaired, and given its first real consumer. `GaloisSelfTensor.lean` is left uncommitted on purpose: it is p1's live work-in-progress (its recent history includes p1 reverting a clobber of it), and committing another lane's in-flight file is the hazard I just filed.

## Next

`AJC.picrep.etale-rep.invariance` (p2, advanced not closed) and the `G2(c)` glued quotient. Caution for anyone consuming my lemma: the level is **existentially quantified** and manufactured from the point, so a consumer at a fixed level owes genericity in the level or an enlargement step — stated in the file, and p2 has accepted it.
