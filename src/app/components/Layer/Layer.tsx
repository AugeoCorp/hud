import type { CSSProperties, ReactNode } from "react";

import styles from "./Layer.module.css";

/**
 * A flat plane of UI at a depth, inside a `<StereoStage>`. `depth` is the
 * total disparity in CSS pixels per eye image: positive sits behind the screen
 * plane, negative pops out, 0 is the screen plane. Keep text people read at 0.
 */
export function Layer({
	depth,
	className,
	children,
}: {
	depth: number;
	className?: string;
	children?: ReactNode;
}) {
	const style = { "--depth": depth } as CSSProperties;

	return (
		<div
			className={className ? `${styles.layer} ${className}` : styles.layer}
			style={style}
		>
			{children}
		</div>
	);
}
