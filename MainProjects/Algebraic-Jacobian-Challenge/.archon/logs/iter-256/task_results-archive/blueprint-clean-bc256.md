# Blueprint-clean report — bc256 (iter-256)

**Scope:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
**Edited lemmas reviewed:** `lem:dual_restrict_iso` (proof lines 5514–5622) and `lem:sheafofmodules_hom_of_local_compat` (proof lines 5846–6027).

---

## Finding and fix

**One Lean term syntax instance removed** from the `lem:sheafofmodules_hom_of_local_compat` proof,
sub-step (c.ii), former line 5990:

- **Before:** `\((U_i).\iota.\mathtt{appIso} = \mathtt{Iso.refl}\)`
- **After:** `\(\mathtt{appIso}(\iota_i) = \mathtt{Iso.refl}\)`

The original expression used a three-deep Lean dot-chain field accessor `(U_i).\iota.\mathtt{appIso}`,
accessing the `appIso` field of the open-immersion `\iota` of the scheme `U_i` — this is Lean term
syntax, not mathematical notation.
The replacement names `\mathtt{appIso}` and `\mathtt{Iso.refl}` as Lean/Mathlib identifiers (allowed
per directive) and expresses the equation in conventional function-application style.

---

## Full checklist

### `lem:dual_restrict_iso` proof block (H1 + Leg A/B restructure)

| Check | Result |
|---|---|
| Tactic strings (`erw`, `refine`, `simp only`, etc.) | None found |
| `by` blocks | None found |
| Lean term syntax (dot-chains, type annotations, etc.) | None found |
| `\uses{}` well-formed | ✓ `\uses{lem:internal_hom_isSheaf, lem:restrictscalars_ringiso_dualequiv}` — both label tokens |
| `% SOURCE:` comment intact | ✓ Lines 5487–5489 |
| `% SOURCE QUOTE:` intact + matches | ✓ Lines 5490–5500; verbatim Stacks quote preserved |
| `\leanok` / `\mathlibok` markers untouched | ✓ |

The H1 stage formula uses `(\mathtt{pushforward}\,\beta).\mathtt{obj}` and `M.\mathtt{val}` — these
are established blueprint notation for functor application (`.obj`) and the underlying presheaf
(`.val`) throughout this project, and are not tactic/term leakage.

### `lem:sheafofmodules_hom_of_local_compat` proof block (sub-step (c) smul-bridge expansion)

| Check | Result |
|---|---|
| Tactic strings | None found |
| `by` blocks | None found |
| Lean term syntax | **1 instance fixed** (see above) |
| `\uses{}` well-formed | ✓ `\uses{def:scheme_modules_homMk, lem:open_immersion_slice_sheaf_equiv}` — both label tokens |
| SOURCE comments | Correctly absent (Archon-original result) |
| `\leanok` / `\mathlibok` markers untouched | ✓ |

---

## Summary

One edit made. Both proof blocks are now free of tactic/Lean-term leakage. `\uses{}` lists are well-formed. Source comments are intact. No `\leanok` markers were added or removed.
