# Lean Audit Report

## Slug
ts226

## Iteration
226

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **[L69–73] File header blueprint-pin list names a non-existent declaration.** Item 3 of the "4 blueprint-pinned declarations" is `AlgebraicGeometry.Scheme.Modules.monoidalCategory`, described as the full `MonoidalCategory (X.Modules)` instance. This declaration does not exist in the file. §2 (L1587–1597) explicitly records the deliberate decision *not* to build it and states "they are removed here." The header was not updated when the instance was removed.
  - **[L1987–2003] `exists_tensorObj_inverse` docstring "iter-218 INCOMPLETE gate" section is factually stale.** Two statements are now false at iter-226: (a) "The construction is blocked at its FIRST step — `Linv` cannot even be named" — `Linv := Scheme.Modules.dual L` *is* nameable since iter-225. (b) "per the INCOMPLETE gate we do NOT push a `dual`-shaped helper-sorry forward (the iter-214 d.1 anti-pattern)" — this decision has been reversed; the body comment at L2009 explicitly exploits `Scheme.Modules.dual`. The docstring and the body comment now contradict each other.
  - **[L2002] Stale line-number cross-reference.** The docstring for `exists_tensorObj_inverse` references "at L1349" for `tensorObj_isLocallyTrivial`, but the declaration is at L1912 (difference of ~563 lines). The second cross-reference at L2020 ("L1920") is approximately correct (within the same declaration's proof body).
  - **Focus-1 `isIso_of_isIso_restrict` (L1943–1975): statement is well-formed and non-vacuous.** The signature `(U : X → X.Opens) (hxU : ∀ x, x ∈ U x) (h : ∀ x, IsIso ((restrictFunctor (U x).ι).map φ))` is the natural "covering family indexed by points" formulation, equivalent to the standard "∃ open cover on which φ is iso" formulation. It is neither weaker (the `hxU` condition ensures the family covers `X`) nor stronger (one can always index a given cover by points). The hypotheses are exactly what a "locally-iso ⇒ iso" statement should have.
  - **Focus-1 proof (L1946–1975): no dead-end or no-op tactics.** The proof route is coherent:
    1. For each `x`, witnesses `x' : U x` with `(U x).ι x' = x` via `Scheme.Opens.opensRange_ι` + `Scheme.Hom.mem_opensRange`.
    2. `haveI hFφ` at L1957–1959: `dsimp only [Functor.comp_map]` unfolds the triple composite, then `exact Functor.map_isIso _ _` uses `h x` (in scope as `haveI` at L1955) — instance synthesis chains through the three functors. The file compiles without errors; no dead end.
    3. `NatIso.isIso_map_iff (restrictStalkNatIso (U x).ι x') φ` correctly transfers `IsIso` along the natural iso `F₁ ≅ F₂` between `(restrictFunctor (U x).ι ⋙ toPresheaf (U x) ⋙ stalkFunctor Ab x')` and `(toPresheaf X ⋙ stalkFunctor Ab ((U x).ι x'))`.
    4. `hx' ▸ hGφ` reindexes the stalk point from `(U x).ι x'` to `x`.
    5. The `TopCat.Sheaf Ab X` packaging (L1967–1970) and `isIso_of_stalkFunctor_map_iso` (L1971) plus `isIso_iff_of_reflects_iso` (L1975) close correctly. No issues.
  - **Focus-3 sorry at L641** (`isLocallyInjective_whiskerLeft_of_W`): carries a detailed explanatory comment (L614–640) identifying the two gaps (d.1-bridge and d.2). Honest. Not silently masked.
  - **Focus-3 sorry at L2027** (`exists_tensorObj_inverse`): body comment (L2009–2026) is honest about bridges A and C remaining, and the d.2-dead-end. The *docstring* is partially stale (see major finding above), but the sorry itself is not silently masked.
  - **Focus-3 sorry at L2073** (`addCommGroup_via_tensorObj`): no inline comment inside the proof body. The docstring (L2058–2068) identifies it as "iter-202 Lane TS scaffold: typed `sorry`" and the closure target once `exists_tensorObj_inverse` lands. This is adequate explanation. Not silently masked.

---

## Must-fix-this-iter

None. The stale comments do not meet must-fix criteria (no wrong definition bodies, no excuse-comments on code, no axioms on substantive claims, no weakened definitions).

---

## Major

- `TensorObjSubstrate.lean:69–73` — File header lists `AlgebraicGeometry.Scheme.Modules.monoidalCategory` as blueprint-pinned declaration #3. The declaration does not exist. §2 (L1587–1597) explicitly records its removal. Any reader (or blueprint checker) using the header as an index of the file's contents will be misled.
- `TensorObjSubstrate.lean:1987–2003` — The "iter-218 INCOMPLETE gate" section of the `exists_tensorObj_inverse` docstring contains two statements that are now false: "`Linv` cannot even be named" (false since iter-225) and "we do NOT push a `dual`-shaped helper-sorry forward" (reversed by iter-226's body). The docstring and body comment contradict each other. A future prover reading only the docstring would receive incorrect infrastructure information.

---

## Minor

- `TensorObjSubstrate.lean:2002` — "at L1349" is a stale line-number reference; `tensorObj_isLocallyTrivial` is at L1912.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 1
- **excuse-comments**: 0

Overall verdict: The file compiles clean (no LSP errors), `isIso_of_isIso_restrict` is well-formed with a correct proof, and all three expected sorries are honestly documented — but the file header names a deleted declaration and the `exists_tensorObj_inverse` docstring contradicts its own body comment on infrastructure availability.
