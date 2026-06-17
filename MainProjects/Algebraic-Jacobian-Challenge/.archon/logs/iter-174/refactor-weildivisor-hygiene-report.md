# Refactor Report

## Slug
weildivisor-hygiene

## Status
INCOMPLETE — Change 1 landed; Changes 2 and 3 are NOT APPLICABLE (both
revert) because the directive's diagnostic premises are factually wrong
in this toolchain. The Lean kernel and the deprecation table contradict
the lean-auditor findings the directive forwarded. Both were tried,
caused regressions, and have been reverted to the prior (correct) state.

## Directive (summary)

Three hygiene findings flagged as must-fix-this-iter by `lean-auditor iter173`:

1. WeilDivisor.lean:70-77 — section docstring still references the old
   `isCodim1AndIntegral` field and an iter-173 refinement plan. Rewrite as a
   short up-to-date description of `Scheme.PrimeDivisor`.
2. WeilDivisor.lean:207 — `noncomputable def degree_hom : X.WeilDivisor →+ ℤ
   := Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)` carries a "redundant"
   `noncomputable` modifier. Drop it.
3. Genus0BaseObjects.lean:237 — `push Not at h` is an "uncommon spelling";
   change to `push_neg at h`.

## Changes Made

### File: AlgebraicJacobian/RiemannRoch/WeilDivisor.lean

**(a) Docstring repair (lines 70-77) — LANDED.**

Replaced the stale section comment that referenced the old
`isCodim1AndIntegral` field and the iter-173 refinement promise with a
short (6-line) description of the structure as it now exists:

```
A prime divisor is encoded by its **generic point** together with the
codimension-one witness `Order.coheight point = 1`: the data field `point : X`
selects the generic point of the closed integral subscheme, and the predicate
field `coheight` enforces codimension one in the specialisation preorder
(Hartshorne II §6 p. 130; blueprint pin `def:prime_divisor`). Integrality of the
closure is automatic, so no separate integrality witness is needed.
```

No reference to `isCodim1AndIntegral` / `True := trivial` / iter-173 plan
remains. Hartshorne II §6 + blueprint pin `def:prime_divisor` cited. ≤ 8
lines.

**(b) `noncomputable` removal on `degree_hom` (line 207) — REVERTED.**

Initially dropped `noncomputable` as the directive requested, then
ran `lake build AlgebraicJacobian.RiemannRoch.WeilDivisor`. The Lean
compiler rejected the change with:

```
error: AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:206:4: failed to
compile definition, consider marking it as 'noncomputable' because it
depends on 'Finsupp.instAddZeroClass', which is 'noncomputable'
```

The body `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)` produces an
`AddMonoidHom (X.PrimeDivisor →₀ ℤ) ℤ`, and the kernel insists that
constructing this term goes through `Finsupp.instAddZeroClass`, which
**is** flagged `noncomputable` in Mathlib. So the directive's premise
("the body is computable") is wrong as a kernel fact, regardless of
surface readability. Reverted to the original `noncomputable def`.
Build returns to green with the original 5 sorries.

(For the next iteration: this looks like a stale lean-auditor signal.
Eliminating the `noncomputable` here would require either swapping the
underlying carrier off `Finsupp` or supplying a computable `AddZeroClass`
instance for `X.PrimeDivisor →₀ ℤ` — neither of which is hygiene-scoped.
Recommend `lean-auditor` add a "tried to remove `noncomputable` and the
kernel rejected it" downgrade rule.)

### File: AlgebraicJacobian/Genus0BaseObjects.lean

**(c) `push Not at h` → `push_neg at h` (line 237) — REVERTED.**

Initially applied the substitution, then built the module. The compiler
emitted:

```
warning: AlgebraicJacobian/Genus0BaseObjects.lean:237:8: `push_neg`
has been deprecated. Prefer using `push Not` instead.
If you'd rather continue using `push_neg` in your project, you can
implement it as follows:
[ macro definition omitted ]
```

So in this toolchain (Lean 4.30.0-rc2 + current Mathlib pin), `push_neg`
is the **deprecated** name and `push Not` is the modern spelling — the
exact opposite of what the directive claimed. Reverted to `push Not at
h`. Build returns clean (no deprecation warning).

(Suggested follow-up: `lean-auditor`'s "uncommon spelling" heuristic
needs a Mathlib-deprecation cross-check. `push Not at h` is the
*recommended* spelling now; flagging it as uncommon is a false positive
that this directive surfaces as actionable.)

## New Sorries Introduced
None.

## Compilation Status
- `lake build AlgebraicJacobian.RiemannRoch.WeilDivisor` — green, 5 sorries (lines 140, 170, 232, 247, 268). Sorry count unchanged.
- `lake build AlgebraicJacobian.Genus0BaseObjects` — green, 8 sorries (lines 186, 193, 768, 944, 961, 1025, 1105, 1135). Sorry count unchanged.
- `lake build AlgebraicJacobian` — green, build completes successfully (8336 jobs).

## Notes for Plan Agent

- Only the docstring repair was actionable as written. The remaining two
  must-fix-this-iter items rest on incorrect premises about the
  toolchain and should be retracted or re-scoped.

- **Change 2 (`noncomputable degree_hom`) is not removable without
  structural work.** The kernel forces `noncomputable` via
  `Finsupp.instAddZeroClass`. If the goal is genuinely "make
  `degree_hom` computable" rather than "remove a redundant marker",
  that's a real refactor (replace the `Finsupp` carrier with a
  computable equivalent), not a hygiene edit. Suggest closing the audit
  finding as "false positive — kernel-required marker".

- **Change 3 (`push Not at h` → `push_neg at h`) was a regression in
  this toolchain.** `push_neg` is the deprecated spelling on Lean
  4.30.0-rc2 / current Mathlib. The lean-auditor signal here is
  backwards; the existing source is already correct. Suggest closing
  the audit finding as "false positive — flagged spelling is the
  current Mathlib recommendation".

- Recommend the plan agent leave a note for the lean-auditor descriptor
  to cross-check `noncomputable` removals against `lake build` and
  cross-check tactic-spelling complaints against the latest Mathlib
  deprecation table before forwarding them as must-fix.

- The docstring repair achieves what the directive intended for that
  item (no misleading prose about `isCodim1AndIntegral` survives; the
  current two-field shape of `Scheme.PrimeDivisor` is now described
  accurately).
