# Blueprint-clean report — iter-208 — Picard_TensorObjSubstrate.tex

**Status:** PASS — chapter is now purity-clean.

## Issues found and fixed

### 1. Stale `% NOTE` comments: "(which is blocked on lem:restrictscalars_laxmonoidal)"

Four `% NOTE` blocks inside `lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`,
`lem:tensorobj_comm_iso`, and `lem:pullback_compatible_with_tensorobj` contained
the parenthetical "(which is blocked on lem:restrictscalars_laxmonoidal)".
This was correct under the old route where `lem:tensorobj_restrict_iso` depended
on the lax-monoidal supplement, but is false after the Route A rewrite:
`lem:tensorobj_restrict_iso` now uses open-immersion sectionwise base change and
does not depend on `lem:restrictscalars_laxmonoidal`.

**Fix:** Removed the parenthetical from all four locations; each NOTE now reads
`% NOTE: no Lean declaration yet; blocked on lem:tensorobj_restrict_iso.`

### 2. Stale `% NOTE` in `lem:tensorobj_lift_onproduct`

The multi-line NOTE ended with
`% \cref{lem:tensorobj_restrict_iso} (itself blocked on`
`% \cref{lem:restrictscalars_laxmonoidal}).`

**Fix:** Collapsed to `% \cref{lem:tensorobj_restrict_iso}.`

### 3. Dead-route flatness claim in `lem:tensorobj_assoc_iso` proof

The proof contained "every tensor product occurring on either side is again a
line bundle, **hence flat, so** `\cref{lem:tensorobj_restrict_iso}` applies".
The "hence flat" claim is residue of the old route where flatness was a
precondition. Route A's `lem:tensorobj_restrict_iso` holds for **all**
`O_X`-modules; no flatness hypothesis enters.

**Fix:** Replaced with "is again a line bundle; `\cref{lem:tensorobj_restrict_iso}`
(which holds for arbitrary `O_X`-modules) applies".

### 4. False flatness attribution in `lem:pullback_compatible_with_tensorobj` proof

The proof read "the same **flat-exactness** / restriction-compatibility argument
**as in** `\cref{lem:tensorobj_restrict_iso}` (extension of scalars along A→B
**is itself flat**, so the comparison is an isomorphism)".
This falsely implied `lem:tensorobj_restrict_iso` uses a flatness argument.
Additionally, flatness of A→B is not required here either — the comparison is an
isomorphism because both sides are locally-free rank-one modules.

**Fix:** Removed the "flat-exactness / as in lem:tensorobj_restrict_iso" framing
and replaced with a locally-free-rank-one argument that does not invoke flatness
and does not misattribute the restriction iso's proof strategy.

## Confirmed clean

- No mention of `leftAdjointOplaxMonoidal`, `oplax`, or `δ`-mate route anywhere.
- No iter-number or "Route A" narrative in the prose.
- No Lean tactic syntax present.
- `lem:restrictscalars_laxmonoidal` retained with correct off-path framing in both its
  `% NOTE` and its statement body; it correctly declares it is NOT an ingredient of
  `lem:tensorobj_restrict_iso`.
- `lem:tensorobj_restrict_iso` statement and proof describe Route A cleanly:
  open-immersion sectionwise base change via `f.appIso` ring isomorphism and
  `ModuleCat.restrictScalarsEquivalenceOfRingEquiv`; no flatness anywhere.
- `% SOURCE` discipline: no `% SOURCE QUOTE` was invented for the bespoke proof;
  the two existing `% SOURCE QUOTE` blocks (Kleiman §2, Defs. df:aPf + df:Pfs)
  are correctly scoped to the Picard-functor motivation and the `AddCommGroup`
  consumer theorem — both are legitimate external citations with verbatim quotes.
- No spawning of `reference-retriever` needed.
